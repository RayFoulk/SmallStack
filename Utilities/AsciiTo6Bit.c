//-------------------------------------------------|
// Copyright (c) 2016 Raymond M. Foulk IV
//
// Permission is hereby granted, free of charge, to
// any person obtaining a copy of this software and
// associated documentation files (the "Software"),
// to deal in the Software without restriction,
// including without limitation the rights to use,
// copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is
// furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission
// notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
// WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
// AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//-------------------------------------------------|

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

//-------------------------------------------------|
// TODO: static const lookup table for 6bit (name
// TBD) inclusion and generate conversion formula.

// inclusive ascii ranges
// 0x20 -> 0x40  33 chars
// 0x5B -> 0x7F  37 chars
// too many chars

// for certain:
// 0x30 '0' -> 0x39 '9'  10 chars
// 0x61 'a' -> 0x7A 'z'  26 chars

// 0x00 NUL \  4 chars
// 0x08 BS  |
// 0x0A LF  |
// 0x11 DC1 /

// 40 total, 24 remaining
// 0x20 ' ' -> 0x2F '/'    16 chars
// 0x3A ':' -> 0x40 '@'	7 chars
// 63 total, 1 remain
// would have to be '\'

//-------------------------------------------------|
// Character descriptor applicable to either ASCII
// or 6bit.  For ASCII we only need this for non-
// printable characters, but for 6bit it is
// necessary for the whole table(s).
typedef struct
{
    uint8_t code;
    char * brev;
    char * desc;
}
char_desc_t;

//-------------------------------------------------|
// Descriptors for ASCII control characters
static const char_desc_t ascii_ctrl_desc[] = 
{
    { 0x00, "NUL", "Null" },
    { 0x01, "SOH", "Start of Heading" },
    { 0x02, "STX", "Start of Text" },
    { 0x03, "ETX", "End of Text" },
    { 0x04, "EOT", "End of Transmission" },
    { 0x05, "ENQ", "Enquiry" },
    { 0x06, "ACK", "Acknowledge" },
    { 0x07, "BEL", "Bell" },
    { 0x08, "BS",  "Backspace" },
    { 0x09, "HT",  "Horizontal Tab" },
    { 0x0A, "LF",  "Line Feed" },
    { 0x0B, "VT",  "Vertical Tab" },
    { 0x0C, "FF",  "Form Feed" },
    { 0x0D, "CR",  "Carriage Return" },
    { 0x0E, "SO",  "Shift Out" },
    { 0x0F, "SI",  "Shift In" },
    { 0x10, "DLE", "Data Link Escape" },
    { 0x11, "DC1", "Device Control 1" },
    { 0x12, "DC2", "Device Control 2" },
    { 0x13, "DC3", "Device Control 3" },
    { 0x14, "DC4", "Device Control 4" },
    { 0x15, "NAK", "Negative Acknowledge" },
    { 0x16, "SYN", "Synchronous Idle" },
    { 0x17, "ETB", "End of Transmission Block" },
    { 0x18, "CAN", "Cancel" },
    { 0x19, "EM",  "End of Medium" },
    { 0x1A, "SUB", "Substitute" },
    { 0x1B, "ESC", "Escape" },
    { 0x1C, "FS",  "File Separator" },
    { 0x1D, "GS",  "Group Separator" },
    { 0x1E, "RS",  "Record Separator" },
    { 0x1F, "US",  "Unit Separator" },
    { 0x7F, "DEL", "Delete" },
    { 0x00, NULL,  NULL }
};

//-------------------------------------------------|
// TBD: Descriptors for all 6bit chars
// NOT NECESSARY if an algorithmic method is
// determined, which is the point of this excercise
//{ 001, "LCT", "Lower Character Table" },
//{ 002, "UCT", "Upper Character Table" },
//{ 003, "SCS", "Single Character Shift" },
// These were painful to let go of
//{ 003, "ESC", "Escape" },
//{ 004, "CTL", "Control" },
static const char_desc_t fch12_ctrl_desc[] = 
{
    { 000, "NUL", "Null" },
    { 001, "BS",  "Backspace" },
    { 002, "LF",  "Line Feed" },
    { 003, "SH",  "Shift" },
    { 004, "U",   "Up" },
    { 005, "D",   "Down" },
    { 006, "L",   "Left" },
    { 007, "R",   "Right" },
    { 000, NULL,  NULL }
};

//-------------------------------------------------|
// Need to modify this to search any given table
static const char_desc_t * getdesc(
    char_desc_t * table, uint8_t ch)
{
    int8_t index = 0;

    while(table[index].brev != NULL)
    {
        if(table[index].code == ch)
        {
            return &table[index];
        }

        index++;
    }

    return NULL;
}

//-------------------------------------------------|
static const char *binstring(uint8_t ch)
{
    static char binstr[9] = {
        0, 0, 0, 0, 0, 0, 0, 0, 0
    };

    uint8_t bitmask = 0x80;
    uint8_t index = 0;

    for (bitmask = 0x80; bitmask > 0x00;
        bitmask >>= 1)
    {
        binstr[index++] = (ch & bitmask) ?
            '1' : '0';
    }

    return binstr;
}

//-------------------------------------------------|
static void ascii_char_line(FILE * out, uint8_t ch)
{
    char chstr[4] = { 0, 0, 0, 0 };
    char decstr[4] = { 0, 0, 0, 0 };
    char * decfmt;
    char * chptr = "";
    char_desc_t * desc;

    if (isprint(ch))
    {
        sprintf(chstr, "\'%c\'", ch);
        chptr = chstr;
    }
    else
    {
        desc = getdesc(ascii_ctrl_desc, ch);
        if (desc != NULL)
        {
            chptr = desc->brev;
        }
    }

    if (ch < 10)
    {
        decfmt = "  %d";
    }
    else if (ch < 100)
    {
        decfmt = " %d";
    }
    else
    {
        decfmt = "%d";
    }

    sprintf(decstr, decfmt, ch);
    fprintf(out, "    B%s = %s,  // 0x%02X %s\n",
        binstring(ch), decstr, ch, chptr);
}

//-------------------------------------------------|
int main(int argc, char *argv[])
{
    FILE * out = stdout;
    char * outName = "/sdcard/!ascii.h";

    uint16_t first = 0x00;
    uint16_t last = 0xFF;
    uint16_t ch;

    //if(argc > 1)
    //{
        out = fopen(outName, "w");
        if (!out)
        {
            fprintf(stderr,
                "ERROR: fopen(\"%s\") failed",
                outName);
        }
    //}

    fprintf(out, "typedef enum\n");
    fprintf(out, "{\n");

    for(ch = first; ch <= last; ch++)
    {
        ascii_char_line(out, ch);
    }

    fprintf(out, "}\n");
    fprintf(out, "ascii_table_t;\n");

    fclose(out);

    return 0;
}

