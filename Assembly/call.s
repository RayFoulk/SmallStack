;; Note: Manually selecting the return stack pointer
;; may not always be necessary depending on context,
;; but putting things in a known state will work in
;; all cases.

:subrtna
zsl     ; zero selectors
inc csl ; csl ram bank 1
inc psl ; psl data stack

:pushargs
...     ; push all arguments to data stack
...
skw
...
...
:pushaddr
dec psl ; psl back to return stack
shl 6   ; zero out acc
shl 6
lol 4   ; load nip offset (+4 words) in acc
mtr bop ; put nip offset into operand
zca     ; clear carry
mfr nip ; get nip into accumulator
add     ; add nip offset into accumulator
skw     ; push return address to stack
:callsubrtnb
load :subrtnb  ; this is actually 4 x lol
mtr nip ; jump to subroutine
:continue
...     ; point where code returns to
...
...

:subrtnb
...     ; do a bunch of stuff...
...
...

;; with new opcodes and nip inside ptr[7]
:doreturn
zsl     ; zero selectors to return stack
inc csl ; chip select ram bank 1
skr     ; pop return stack to acc
dec psl ; underflow psl to nip
mtr ptr ; jump to return address

