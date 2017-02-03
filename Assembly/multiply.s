; could use a high ptr[] register to store jump address for prologue


mult3:  skr     ; read some value from rom or ram
        a2b     ; copy value to operand
        shl 1   ; multiply accumulator by 2 TODO: Check overflow
        add     ; add operand to accumulator, result is value x 3
        
mult5:  skr     ; read some value from rom or ram
        a2b     ; copy value to operand
        shl 1   ; multiply accumulator by 4
        shl 1
        add     ; add operand to accumulator, result is value x 5
        
        
        
    
