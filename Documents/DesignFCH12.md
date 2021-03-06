# FCH12: 12-Bit MISC CPU Design

### Overview

- Harvard Architecture
    - Single, Pluggable 4K ROM
        - Similar to early game consoles
    - One or More 4K RAM Modules
        - Segmented Addressing
        - Data Only, Non-Executable
    - No Interrupts! (yet)
        - Poll terminal within main loop for input
- Rudimentary Stack Functionality
    - Sythesized using lower-level opcodes
    - Future Designs will be a true Stack Machines
- Registers, Address, and Data bus are 12 bits wide
- Opcodes are  6 bits with (mostly) implied operands
    - 2 opcodes per ROM fetch.
    - Hardwired microcode sequence is: fetch-exec-exec
- Instruction Pointer & Jumps point to odd # instructions
    - Will need to fill in NOPs here and there.
    - "Big Endian" (in terms of 6-bit char order)

### CPU Diagram

    Machine & Bus Layout:
           ___              ___
    [CLK] |   |-[BOP]------|   \---[MCS]--\
       |  |DEC|   ||       |ALU|=\\  || \  \   _
    [INS]-|___|---||-[ACC]-|___/ ||  || |   \=| |==...
      ||       \  ||   ||        ||  || |     | |
      =========|========================|=====|C|==... 
      =========|===== DATA BUS =========|=====|P|==... 
      =========|========================|=====|U|==... 
      ||       |                     || /     | |
    [NIP]------+-------------------[PTR][]    |S|
      ||                             ||       |O|
      ========================================|C|==... 
      =============== ADDR BUS ===============|K|==... 
      ========================================|E|==... 
                                              |T|
                                              |_|

### Internal Data Bus

List of Registers & Devices
Interfaced with Internal Main Data Bus

Mnemonic | Access | Description
|---|---|---|
INS | (WO) | Instruction word register for decode (2 x 6-Bit Opcodes)
ACC | (RW) | Accumulator: 1st ALU input and output
BOP | (RW) | Operand: 2nd ALU input for dyadic funcs. 
ALU | (RO) | ALU output to data bus
MCS | (RW) | Machine Control & Status: Carry, Compare, Device Select, Pointer Select
PTR | (RW) | Peripheral Address (ROM/RAM/etc) Selectable Register Bank (Inludes NIP!). See table below
SKT | (RW) | CPU Socket: Bi-Directional Tristated Peripheral Device I/O and other dedicated interface pins.

### CPU socket layout:

- Bidirectional Data Bus: 12 pins
- Output Address Bus: 12 pins
    - Driven by PTR[PSL] or NIP during instruction fetch
- Output Device Select: 3 pins
    - CSL Intended to drive chip select on peripherals
- Data Mode (8080 Style) Read/Write: 2 pins
- Other Pins
    - Multiple Grounds (GND), Multiple Voltage In (VDD)
    - Reset (RST), Halt (HLT), Clock In (CLKi), Clock Out (CLKo)

#### Layout Option 1

Rough Total Pins (From Above): 33 (div 4 = 8.25)
Round up to 9 on a side (assuming square chip)
and include extra GNDs & VDDs, also CLK_IN/CLK_OUT
new total is 9 x 4 = 36 pins

      _|_|_|_|_|_|_|_|_|_
    --|                 |--
    --|                 |--
    --|                 |--
    --|                 |--
    --|      C P U      |--
    --|                 |--
    --|                 |--
    --|                 |--
    --|_________________|--
       | | | | | | | | |

#### Layout Option 2

Alternative Rectangular Layout
(Would keep Data Bus on one side
and Address Bus on the other)
36 pins - 24 = 12 remaining, / 2 = 6

      _|_|_|_|_|_|_
    --|           |--
    --|           |--
    --|           |--
    --|           |--
    --|           |--
    --|           |--
    --|   C P U   |--
    --|           |--
    --|           |--
    --|           |--
    --|           |--
    --|___________|--
       | | | | | |

### Inter-Register Transport Notes

- ROM to INS: Read-Only from ROM to Write-Only for INS
- ALU output: Write-Only to Data Bus)
- Accumulator-centric transport instructions
- ACC is used for unary operations
- BOP is used with ACC for all dyadic operations
- BOP will have a bypass MUX at ALU for ops like INC, DEC, JCP

#### Special Case Transport

    INS <-- SKT     Fetch Instr. hardcoded in 18-bit INS,
                    Read line overrides CSL out to 0
                    also overrides ADDR_BUS with NIP out
                    NOTE: SKW with CSL 0 is illegal

    ALU --> ACC     Driven by ALU opcodes,
                    Implied operands are ACC and BOP

    ALU --> NIP     Cond. Relative Jump instruction JCP,
                    Overrides BOP before ALU

    ACC <-> SKT     RAM Read/Write or ROM Read, all
                    expect manually driving CSL
                    Internal R/W lines auto drive
                    INC/DEC of PTR[PSL]

#### Normal Case Transport (Simple Internal Data R/W)

    ACC <-> BOP     Swap would be nice in some cases,
    ACC <-> MCS     but these are all overwrite copy.
    ACC <-> PTR     Writing to MCS will clear/set carry
    ACC <-> NIP     and compare bits. Writing to NIP
                    will also of course jump absolute!
                    Writing to PTR and PSL drives the
                    address bus to ROM/RAM/(EEPROM)

#### MCS Register Layout:

Upper two octets R/W are hardwired to ALU in/out.
In this way, the MCS resembles ACC except reversed.
writing ACC => MCS with zero in upper char clears
carry and compare bits.  ADD is always with carry.
CSL and PSL octets could be independent up/dn
counters to all for next/prev-dev and PSL instr.
PTR[] registers may be used for temporary storage
to simulate ROR and ROL operations.  Future usage
for some reserved bits include greater/less
comparison and also signed versus unsigned
operations.

     11  10   9 | 8   7   6 | 5   4   3 | 2   1   0
    [RES RES CMP|RES RES CAR|    CSL    |    PSL   ]

#### General / Accumulator Register Layout:

     11  10   9 | 8   7   6 | 5   4   3 | 2   1   0
    [ Most Sig  | Next-Most | Next-Least| Least Sig ]
    [  Octet 3  |  Octet 2  |  Octet 1  |  Octet 0  ]
    [  High Char (HCHAR)    |  Low Char (LCHAR)     ]

### Address Pointer (PTR[PSL]) Register Bank Behavior

One of these can be selected at any time via the PSL
bit field in the MCS register.  The currently
selected register in the PTR[] bank drives the ADDR
bus output lines, as well as having its incrementor
and decrementor lines connected to the decoder,
such that on socket R/W (and thus stack R/W) operations
cause the applicable in-place INC/DEC (if and where
applicable).  When N/A the register value remains
static unless purposefully assigned or driven by
inc ptr / dec ptr operations.

| PSL     | On SKW   | On SKR   | Intended Usage
|---------|----------|----------|---
000  (d0) | PTR[0]-- | PTR[0]++ | Return Stack
001  (d1) | PTR[1]-- | PTR[1]++ | Data Stack
010  (d2) | N/A      | N/A      | General Purpose
011  (d3) | N/A      | N/A      | General Purpose
100  (d4) | N/A      | N/A      | General Purpose
101  (d5) | N/A      | N/A      | General Purpose
110  (d6) | N/A      | N/A      | General Purpose
111  (d7) | INVALID  | PTR[7]++ | Instruction Pointer (NIP)

For this first iteration, I'm sticking to a simplified
hardware design, and relying on startup code / ROM
software to manage stacks.  Stack sizes can be computed
easily.

General Purpose / Subroutine Argument Registers
(Arguments can be pointer or literal value,
address bus output at socket is only enabled
during socket read/write).

### High Level Assembler Keywords

These are replaced by opcode sequences and
literal numeric values by the assembler
and object linker

| Keyword | Opcode Sequence | Description |
|---------|-----------------|-------------|
data | N/A | At the beginning of a source file, designate the entire file as global data.  The assembler and linker will create a special label named "data".
link \<number\> | N/A | Optionally once at the beginning of a source file, specify the linker order of the object.  startup.s should be 0.
:\<label\> | N/A | Apply a label to a subroutine, location, or data
load \<label\> | lol label_oct3<br>lol label_oct2<br>lol label_oct1<br>lol label_oct0<br> | Load the address of a label into acc
call \<label\> | zsl<br>pra<br>load \<label\><br>mtr nip<br>nop ; as determined by assembler<br> | Push return address and call subroutine
retn | zsl<br>skr<br>mtr nip<br> | Pop address and return from a subroutine

### Opcode Table

##### Group 0: Essentials, Special Transport
- pra is intended to help with call sequence
    - mux bypass of bop with constant
    - mux bypass of acc with nip output
    - add function is used, but carry bypassed to 0
    - output written to socket via bus
    - assumes appropriate stack/memory has been selected
    - acts like skw regarding inc/dec lines

| Binary | Octal | Mnemonic | Description
|--------|-------|----------|---
000000 | 000 | hlt | Halt Execution
000001 | 001 | rst | Reset CPU
000010 | 002 | nop | No Operation
000011 | 003 | --- | RESERVED
000100 | 004 | pra | skt = nip + 4, Push return address
000101 | 005 | --- | RESERVED (could be ret in future TBD)
000110 | 006 | skw | skt = acc, Auto-inc/dec PTR[] if applicable (wired)
000111 | 007 | skr | acc = skt, Auto-inc/dec PTR[] if applicable (wired)

##### Group 1: Normal Transport Operations (Move)
- ACC Implied: 1 bit to/from, 2 bits src/dst
- Requires Argument: bop, mcs, ptr, nip (special case)
- nip moved into PTR[7] for storage, but can be called out specifically
- Introducion of acc/bop swap will reduce opcode count 

| Binary | Octal | Mnemonic | Description
|--------|-------|----------|---
0010XY | 010 to 013 | mtr | Move acc To Register<br>00=BOP, 01=MCS,<br> 10=PTR[PSL], 11=NIP (Absolute Jump)
0011XY | 014 to 017 | mfr | Move From Register To acc<br> 00=BOP, 01=MCS,<br> 10=PTR[PSL], 11=NIP (Get Instr Ptr)

##### Group 2: Incrementors and Decrementors
- All are in-place up/down counter operations
- Requires Argument: acc, ptr, psl, csl

| Binary | Octal | Mnemonic | Description
|--------|-------|----------|---
0100XY | 020 to 023 | inc | Increment Register<br>00=acc,01=PTR[PSL],<br>10=PSL,11=CSL
0101XY | 024 to 027 | dec | Decrement Register<br>00=acc,01=PTR[PSL],<br>10=PSL,11=CSL

##### Group 3: Single Stage Barrel Shifter (Shift Mode)
- Requires Argument: 1, 3, 4, or 6 (Legal number of bits)

| Binary | Octal | Mnemonic | Description
|--------|-------|----------|---
0110XY | 030 to 033 | shl | acc <<= N(XY) where 00=1,01=3,10=4,11=6
0111XY | 034 to 037 | shr | acc >>= N(XY) where 00=1,01=3,10=4,11=6

##### Group 4: Literal Octet Assignment
- Requires Argument: 0 through 7
- Left-shifts by 3 bits and loads ACC Octet 0
- ACC Octet 3 is discarded.
    - This is done by bypassing Octet 3 before the BarrelShifter
    - And asserting the SH/RO line (Rotate Mode)
- Assembler will support a higher level 'load' command (lda)
    - Given some label:, support 'lda label'
    - To facilitate labels & subroutine calls
    - assembler will replace with 4 sequential lol operations
- Labels themselves are also supported by the assembler
- How can the assembler itself be cross-assembled?
    - Probably will have to hand-write it.
    - Depends on board layout & non-volatile storage.
    - This concept best held off until FCH16.

| Binary | Octal | Mnemonic | Description
|--------|-------|----------|---
100XYZ | 040 to 047 | lol | acc Load Octet 0 with XYZ and Rotate acc Left 3

##### Group 5: Rotate Octet + MCS Manipulation
- BarrelShifter (Rotate Mode) used to help with loading specific values into ACC

| Binary | Octal | Mnemonic | Description
|--------|-------|----------|---
101000 | 050 | ror | acc Rotate Octet Right (3 Bits)
101001 | 051 | --- | RESERVED
101010 | 052 | rol | acc Rotate Octet Left (3 Bits)
101011 | 053 | --- | RESERVED
101100 | 054 | neq | mcs[cmp] = ~mcs\[cmp\] (JK Toggle)
101101 | 055 | zca | mcs[car] = 0
101110 | 056 | zsl | mcs[psl] = mcs[csl] = 0
101111 | 057 | --- | RESERVED

##### Group 6: Arithmetic & Logic Operations, with Comparator

| Binary | Octal | Mnemonic | Description
|--------|-------|----------|---
110000 | 060 | eq  | mcs[cmp] = (acc == bop)
110001 | 061 | eqz | mcs[cmp] = (acc == 0)
110010 | 062 | add | acc += bop (Carry mcs[car])
110011 | 063 | sub | acc -= bop (Borrow mcs[car])
110100 | 064 | and | acc &= bop
110101 | 065 | or  | acc \|= bop
110110 | 066 | xor | acc ^= bop
110111 | 067 | not | acc = ~acc

##### Group 7: Conditional Relative Jumps
- Requires Argument: 1 through 15
    - Number of operations to skip over
    - Assember will divide argument by 2 to derive XYZ
    - Assembler will insert nop(s) if necessary
        - To achieve odd numbered jumps
        - To maintain word alignment
        - Depending on position of jcr in ins word
    - Outside of fetch cycle, so normal fetch increment will also occur
- These require a specific calling sequence
    - Normally would execute eq/eqz ... jcr
    - acc is mux bypassed with nip output
    - bop is mux bypassed with argument value
    - ALU output written directly to NIP via bus

| Binary | Octal | Mnemonic | Description
|--------|-------|----------|---
111XYZ | 070 to 077 | jcr | mcs[cmp] ? nip += b000XYZ : continue

### TODO: 
    
- Character table with ASCII conversion algorithm
- Need to decide on ASCII-to-6bit char mapping
    - Possibly have 2 tables: normal and shifted
    - Or keep it simple with 1 table
    - ability to port/play Roguelike games a priority
    - in competition with ability to port Forth.
- Design peripheral interfaces
    - ROM expected at peripheral address 7
        - Why? because fetch overrides psl and dsl with 7,7
        - Because zsl is easiest to implement with zeros
        - thus stack RAM is at 0
    - Graphics - Color LCD
        - 8080 interface. memory mapped CMD/CTRL regs
        - 2 devs possible 12 bit RGB or 9bit 1 dev
    - Monochrome Console LCD
        - 1 dev for cmd & ctrl
    - Keyboard
        - 1 dev: 6 bit low or high char others zero
        - parallel interface? look up early apple 1
    - Hard Disk -- use EEPROM instead?
    - [128K EEPROM](http://ww1.microchip.com/downloads/en/DeviceDoc/doc0395F.pdf)
        - Will have to be external mem-mapped because of interface pinout
        - Control register and Data register
    - External RAM
        - 3 devs: 12 high addr, 12 low addr, 12 data
        - 2 dev: bit fields mux select, value
    - Network
    - Bus extender / reducer for interfacing with
        - 8 to 10 bit hardware: mode addr/data
        - 1 bus addr -- rising edge triggered mode select bit, data apply bit.
        - 2 bus addrs -- can preserve 12 bits

### Main Board Peripheral Bus (8 Addresses)

- Board Layout & Design is flexible here)
- Last Device on bus could be memory map
    - all remaining peripherals use full address and data bus
    - large number of control registers possible!
- Design Example
    - 16K RAM with external 12 bit peripheral bus

| Device Address | Device Type | Description 
|----------------|-------------|---
0 | RAM | [4K RAM](http://www.idt.com/document/70v35342524-data-sheet) (RW) Stacks in Upper 1K, Decompressed Data starts at 0
1 | RAM | 4K RAM (RW) High Memory (Heap) Use 14 bits of 16 bit SRAM chip for these 4 slots
2 | RAM | 4K RAM (RW) High Memory (Heap)
3 | RAM | 4K RAM (RW) High Memory (Heap)
4 | BUS | Put other peripherals here and use addr_bus high bits to select ctrl/data regs
5 | TERM | Parallel Input Keyboard + Simple Text Console TBD
6 | N/A | Empty Slot: Could be data ROM (Fonts, Bitmaps), may need HW stub if empty
7 | ROM | 4K ROM (RO) Pluggable Cartridge

#### Alternate 2-Bit CSL Design

| Device Address | Device Type | Description 
|----------------|-------------|---
0 | RAM | [4K RAM](http://www.idt.com/document/70v35342524-data-sheet) (RW) Stacks in Upper 1K, Decompressed Data
1 | RAM | 4K RAM (RW) High Memory (Heap) Use 14 bits of 16 bit SRAM chip for these 4 slots
2 | BUS | Put other peripherals here and use addr_bus high bits to select ctrl/data regs
3 | ROM | 4K ROM (RO) Pluggable Cartridge

### Memory Model

| RAM Module | Designation | Entries | Address Range (Octal)
|---|---|---|---
0 | Return Stack | 0 to 256 | 7400 to 7777
0 | Data Stack | 0 to Remainder | X to 7377
0 | Heap / Decompressed App Data (Strings, Bitmaps) | 3072 | 0 to (X-1)
1 | Heap / Scratch Pad | 4096 | 0 to 7777
2 | Heap / Scratch Pad | 4096 | 0 to 7777
3 | Heap / Scratch Pad | 4096 | 0 to 7777

### Instruction Design Notes

// Synthesis of other instructions:
GT, LT, GE, LE comparisons, MUL and DIV operations
can be sythesized in software.

// Later Design changes:
single cycle hardware register swap or
 queue would be very useful for ptr/stack/data

ROM shall be separate and socketable.
FCH bypasses CSL and PSL and asserts 1 on all output pins
(forcing selection of PTR[7] (NIP) and peripheral 7 (ROM)
ADDR output pins are normally driven by PTR[PSL]

Explicit fetch opcode is avoided since this can be built
directly into the main micro cycle => drive lines.
I.E. For this "instruction" only, there nothing to
"decode" per se, just do it!

fch   PSL =>7, CSL => 7, INS <= SKT, NIP++ driven by read

##### Instructions to Consider:

N2S and S2N not really necessary as N2A,SKW and
  SKR,A2N will suffice.. although need to load contant
  into operand and premptively ADD to NIP.
  Will require selecting stack ptr

ASB swap ACC <=> BOP and save another opcode
do the same with PTR[]?  ASP? - will require another internal data bus

Nice-to-haves but not necessary (removed from first draft)
swo  ACC[OCT3] <=> ACC[OCT2]
bcd  ACC[4:11] = 0

##### Instruction Trash Bin:

MCS[CMP] = MCS[CAR] for testing carry in 2 instr vs 5
MCS[CMP] = ~MCS[CMP] via JK toggle (reduce #opcodes)
ZHI      ACC[HCHAR] = 0 (Debatable)
// Alternate Comparator Design (Debatable)
// More capable, More complex wiring
NCB      MCS[CMP] = ~MCS[CMP] (JK Toggle)
CCB      MCS[CMP] = MCS[CAR] (Loopback Set)
// NIX..Shifted-out bits go to MCS[RES]
NOTE: ROR or ROL twice will do a high/low char swap
NIX: SWC      ACC[HCHAR] <=> ACC[LCHAR]


### Old Stuff

// Links for Reference:
http://www.learnabout-electronics.org/Digital/images/register-SISO-PISO.gif

// Old (Mostly Outdated) TODO Contents:
- Create shift registers, some power of 2 size large, possibly 8 or 16
	- This will be used for a 'column' in the stack
- Create stack component.
	- dual-read ported on top two elements.
	- push/pop control lines
	- ability to read size via control line assert
- Create ALU
	- Adder/Subtractor
	- Equality comparator only (no magnitude)
	- logical subset
	- shift by one +/-
	- bcd hex operation - mask off all but 4 bits

- Control unit
	- Instruction register split into opcodes
	- in parallel with hardwired fetch cycle microcode
	- microcode pc counter controls a mux through micro opcodes 
	- two decoders - one for reader and one for writer
		- minimize the number of bus targets
		- ALU inputs hardwired to data stack, and dumps directly
		  back to data bus.  it is the writer in an op.
		- memory unit

