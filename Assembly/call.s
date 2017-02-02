; Note: Manually selecting the return stack pointer may not always be
; necessary depending on the context, but this example will work in
; all cases.

args    ...     ; push all subroutine arguments to data stack
        ...     ; put number of arguments in high ptr array

push:   shr 6   ; zero out high char, will clear carry & compare
        oc0 0   ; set psel octet to return stack pointer
        oc1 1   ; set dsel octet to first ram bank
        a2c     ; configure the mcs register
        oc0 5   ; high char still 0, load nip offset (+5 words) in acc
        oc1 0
        a2b     ; put nip offset into operand
        n2a     ; get nip into accumulator
        add     ; add nip offset into accumulator
        skw     ; socket write the address to return stack
                ; and increment stack pointer (push)
                
call:   oc0 3   ; load hypothetical subroutine address 1337 accumulator
        oc1 1
        shl 6
        oc0 7
        oc1 3
        a2n     ; jump to subroutine

cont:   nop     ; point where code returns to
        nop
        nop
        
        
