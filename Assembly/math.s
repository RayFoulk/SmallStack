;; TODO: Implement Rotate Left/Right 1 bit with carry
;; TODO: Implement Shift double-word Left/Right
;; TODO: Implement Multiply & Divide routines
;; TODO: Might be useful to implement IsOdd and/or IsEven => mcs[cmp]
;; TODO: implement subroutines for GreaterThan, LessThan, etc... (>, >=, <, <=)

:mult3
skr     ; read some value from rom or ram
mtr bop ; copy value to operand
shl 1   ; multiply accumulator by 2 TODO: Check overflow
add     ; add operand to accumulator, result is value x 3
        
:mult5:
skr     ; read some value from rom or ram
mtr bop ; copy value to operand
shl 1   ; multiply accumulator by 4
shl 1
add     ; add operand to accumulator, result is value x 5

;; Idea: User a high ptr[] register to store jump address for epilogue
;; i.e. load once and then just copy afterwards (depending on size of code & context)




        
        
        
    
