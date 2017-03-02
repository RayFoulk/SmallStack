# SmallStack
Design &amp; Simulation of a Minimal Instruction Set Computer (MISC)

### Purpose
- To have fun & learn about alternative CPU architectures.
- To create my own hobbyist CPU from scratch.

### What Is This?
- This is a Register-Transfer Level (RTL) simulation of my CPU written using SmartSim, Ashley Newson's wonderful project.
- To run it you will need to install or build SmartSim first, and then open FCH12.ssp

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
- [Current Design](https://github.com/RayFoulk/SmallStack/blob/master/Documents/DesignFCH12.md)

### Research:
- Links regarding hobbyist CPUs
    - [FPGA CPU org](http://www.fpgacpu.org/)
    - [Homebrew CPU](http://www.homebrewcpu.com/)
    - [From NAND to Tetris](http://www.nand2tetris.org/)
- Discovery that "Minimal Instruction Set Computer" is a real thing (MISC)
- Inspired by the life's work of Charles Moore, an unsung genius (in my opinion)
    - Computer Cowboys, Ultratechnology, Greenarrays
    - Stack Computers, RPN, and Forth Language.
- Links regarding Stack Computers:
    - [Wikipedia: Stack Machine](https://en.wikipedia.org/wiki/Stack_machine)
    - [Porting the GNU C Compiler to the Thor Microprocessor (Gunnarsson & Lundqvist, 1995)]
      (http://tlundqvist.org/Publications/thesis95/ThorGCC.pdf)
    - [Stack Computers "The New Wave" (Koopman, 1989)]
      (https://users.ece.cmu.edu/~koopman/stack_computers/)
    - [Stack Computers & Forth (Koopman)]
      (https://users.ece.cmu.edu/~koopman/stack.html)
    - [FPGACPU.CA: Stack Computer Architecture]
      (http://fpgacpu.ca/stack/index.html)
- Links regarding Charles Moore:
    - [Wikipedia: Charles H. Moore]
      (https://en.wikipedia.org/wiki/Charles_H._Moore)
    - [Simple Talk: Chuck Moore: Geek of the Week]
      (https://www.simple-talk.com/opinion/geek-of-the-week/chuck-moore-geek-of-the-week/)
    - [GreenArrays, Inc]
      (http://www.greenarraychips.com/)
        - Affordable evaluation boards available!
        - Fully asynchronous 144 parallel SoC 
    - [UltraTechnology: Charles Moore, Forth, and Computer Cowboys]
      (http://www.ultratechnology.com/cowboys.html)
    - [UltraTechnology: Minimal Instruction Set Computers]
      (http://www.ultratechnology.com/misc.html)
    - [TEDx (Circa 2011?) Charles H. Moore - Software: Past and Future]
      (https://www.youtube.com/watch?v=tb0_V7Tc5MU)
    - [Chuck Moore (Forth) Fireside Chat - May 22 1999]
      (https://www.youtube.com/watch?v=N1FUY6g5crA)

