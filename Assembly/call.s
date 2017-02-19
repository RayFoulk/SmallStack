;; Note: Manually selecting the return stack pointer
;; may not always be necessary depending on context,
;; but putting things in a known state will work in
;; all cases.

:subrtna
zsl     ; zero selectors
:pushargs
inc psl ; psl data stack
shl 6   ; pretend subrtnb takes numeric arg 077
lol 7
lol 7
skw     ; push first arg: 077
lol 1   ; pretend second arg is ptr 1337
lol 3
lol 3
lol 7
skw     ; push second arg: ptr 1337
:pushaddr
dec psl ; back to return stack
shl 6   ; zero out acc
shl 6
lol 4   ; load nip offset (+4 words) in acc
mtr bop ; put nip offset into operand
zca     ; clear carry
dec psl ; select nip
mfr ptr ; get nip into accumulator
add     ; add nip offset into accumulator
inc psl ; back to return stack
skw     ; push return address to stack
:docall
load :subrtnb  ; this is actually 4 x lol
dec psl ; back to nip again
mtr ptr ; jump to subroutine
:continue
...     ; point where code returns to
...
...
...
...

:subrtnb
...     ; check stack size?
...     ; pop args off data stack
...     ; store in ptr array
...     ; do stuff
...

;; with new opcodes and nip inside ptr[7]
:doreturn
zsl     ; zero selectors to return stack
skr     ; pop return stack to acc
dec psl ; underflow psl to nip
mtr ptr ; jump to return address

