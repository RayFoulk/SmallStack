# SmallStack
Design &amp; Simulation of a Minimal Instruction Set Computer (MISC)

### Purpose
- To have fun & learn about alternative CPU architectures.
- To create my own hobbyist CPU from scratch.

### Design Goals:
- Simple, Small, Minimalistic Design (Minimal Instruction Set Computer)
- Early designs will NOT have hardware stacks but will use RAM
    - Will initially resemble typical CPU designs, just to get off the ground
    - Future designs will implement hardware stacks rather than adding registers
- To have a design that still remains truly useful despite its simplicity
    - Don't get stuck in 'Turing Tarpit'
    - Support at minimum 1k instruction words in ROM
    - Be different, to challenge my assumptions and force myself to be creative
- Began with 6-bit design.  Why?
    - Minimum number of bits to support an alphanumeric charset.
    - Also a good size for opcodes / minimalistic instruction set.
- Transitioned to 12-bit design
    - Usable single-cycle indirect addressing (4k space)
    - Maintain 6bit opcodes / characters by packing 2 chars per word.
    - Future designs  may transition to 18-bit design with 3 chars per word

### Research:
- Discovery that "Minimal Instruction Set Computer" is a real thing (MISC)
- Inspired by the life's work of Charles Moore, an unsung genius (in my opinion)
    - Computer Cowboys, Ultratechnology, Greenarrays
    - Stack Computers, RPN, and Forth Language.
- Book: Stack Computers "The New Wave" (Koopman, 1989)

