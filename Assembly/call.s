;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Note: Manually selecting the return stack pointer may not always be
; necessary depending on the context, but this example will work in
; all cases.  Also: if an extended addition or subtraction operation
; is in progress or for whatever reason you don't want the high
; character in MCS to be cleared, then instead, execute:
; mfr mcs, shr 6, lol 1, lol 0, mtr mcs

args:   ...     ; push all subroutine arguments to data stack
        ...     ; put number of arguments in high ptr array?
        ...
        ...

push:   shl 6   ; pull up zero char to clear carry & compare
        lol 1   ; set dsel octet to first ram bank
        lol 0   ; set psel octet to return stack pointer
        mtr mcs ; configure the mcs register
        shr 6   ; hchar still 0, discard all selector bits
        lol 4   ; load nip offset (+4 words) in acc
        mtr bop ; put nip offset into operand
        mfr nip ; get nip into accumulator
        add     ; add nip offset into accumulator
        skw     ; socket write the address to return stack
                ; and decrement stack pointer (push)
                
call:   lol 1   ; load hypothetical subroutine address 1337 into acc
        lol 3
        lol 3
        lol 7
        mtr nip ; jump to subroutine

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

return: shl 6   ; pull up zero char to clear carry & compare
        lol 1   ; set dsel octet to first ram bank
        lol 0   ; set psel octet to return stack pointer
        mtr mcs ; configure the mcs register
        skr     ; pop from return stack into acckumulator
        mtr nip ; jump back to return address (return)
        
