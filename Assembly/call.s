;; Note: Manually selecting the return stack pointer
;; may not always be necessary depending on context,
;; but putting things in a known state will work in
;; all cases. zsl defaults to RAM 0 and return stack

:subrtna
zsl     ; zero selectors
:pushargs
inc psl ; psl data stack
shl 6   ; pretend subrtnb takes numeric arg 055
lol 5
lol 5
skw     ; push first arg: 055
lol 1   ; pretend second arg is ptr 1337
lol 3
lol 3
lol 7
skw     ; push second arg: ptr 1337
call subrtn ; call subroutine b
mfr bop ; return value usually stashed in bop
...
...
...
...
retn

:subrtnb
...     ; pop args off data stack
...     ; store in ptr array
...     ; do stuff
...
retn    ; return from subroutine

