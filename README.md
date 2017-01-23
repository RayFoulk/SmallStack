## SmallStack
Design &amp; Simulation of a Minimal Instruction Set Computer (MISC)

# Purpose
    - To have fun & learn about alternative CPU architectures.
    - To create my own hobbyist CPU from scratch.

# Design Goals:
    - Simple, Small, Minimalistic Design (Minimal Instruction Set Computer)
    - Early designs will NOT have hardware stacks but will use RAM
        - will initially resemble typical CPU designs, just to get off the ground
        - future designs will implement hardware stacks rather than adding registers
    - Have a design that still remains useful despite its simplicity
        - Don't get stuck in 'Turing Tarpit'
        - Support at least 1k instruction words in ROM
        - Be different, to challenge my assumptions and force myself to be creative
            - Originally began with 6-bit design.  Why? this is the minimum number
              of bits to support an alphanumeric charset.  It's also a good size
              for a minimalistic instruction set / opcode.
        - Ended up with 12-bit design, packing two chars per word.
        - Future iterations may transition to 18-bit design

# Research:
    - Discovery that "Minimal Instruction Set Computer" is a real thing (MISC)
    - Inspired by the life's work of Charles Moore, an unsung genius (in my opinion)
        - Computer Cowboys, Ultratechnology, Greenarrays
        - Stack Computers, RPN, and Forth.
    - Book: Stack Computers (Koopman, 1989)
