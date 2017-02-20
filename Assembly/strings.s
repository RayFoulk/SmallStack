;; Calling convention: arguments are expected on the
;; data stack.  caller pushes and pops.  callee just
;; references.  Integer return codes are placed in bop.
;; first arg will usually be the chip id where the
;; data is stored and the second will be the ptr to
;; the data.

:example
zsl     ; zero selectors
inc psl ; psl data stack
shl 6
shl 6
lol 7   ; this is a ROM string (csl 7)
skw
lol 1   ; pretend second arg is ptr 1337 to string
lol 3   ; assembler should support labeling data
lol 3   ; so this could be 'lda myleetstr'
lol 7
skw     ; push second arg: ptr 1337
dec psl ; prepare to call: select return stack
shl 6   ; zero out acc
shl 6
lol 4   ; load nip offset (+4 words) in acc
mtr bop ; put nip offset into operand
dec psl ; select nip
zca     ; clear carry
mfr ptr ; get nip into accumulator
add     ; add nip offset into accumulator
inc psl ; back to return stack
skw     ; push return address to stack
lda strlen
dec psl ; back to nip again
mtr ptr ; jump to subroutine
zsl     ; return to here, reset selectors
mfr bop ; get str len into acc
nop
nop
nop
nop
nop
nop
hlt

;; 
:strlen
zsl
inc psl ; data stack
mfr ptr ; get stack ptr
inc psl ; 1st gp addr reg
mtr ptr ; store stack ptr

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

