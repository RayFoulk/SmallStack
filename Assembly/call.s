;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Note: Manually selecting the return stack pointer may not always be
; necessary depending on the context, but this example will work in
; all cases.  Also: if an extended addition or subtraction operation
; is in progress or for whatever reason you don't want the high
; character in MCS to be cleared, then instead, execute c2a,oc1,oc0,a2c

args    ...     ; push all subroutine arguments to data stack
        ...     ; put number of arguments in high ptr array
        ...
        ...

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
                ; and decrement stack pointer (push)
                
call:   oc1 1   ; load hypothetical subroutine address 1337 into acc
        oc0 3
        shl 6
        oc1 3
        oc0 7
        a2n     ; jump to subroutine

cont:   ...     ; point where code returns to
        ...
        ...
        ...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; subroutine

sub:    ...     ; start of subroutine at nip 1337
        ...     ; do a bunch of stuff...
        ...
        ...
        
return: shr 6   ; zero out high char, will clear carry & compare
        oc0 0   ; set psel octet to return stack pointer
        oc1 1   ; set dsel octet to first ram bank
        a2c     ; configure the mcs register
        skr     ; socket read the return address and decrement
                ; stack pointer (pop)
        a2n     ; jump back to return address (return)
        
        
