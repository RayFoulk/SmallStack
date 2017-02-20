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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; All strings assumed to be word-aligned

:strlen
zsl
inc psl ; data stack
mfr ptr ; get data stack ptr
inc psl ; 1st gp addr reg
mtr ptr ; store stack ptr

;; Get CSL, strip unecessary bits, store in operand
inc ptr ; point to csl value
skr     ; read the csl value
shl 6   ; ensure we only keep least 3 bits
shl 3   ; csl bits are at top
shr 6   ; csl are lined up with mcs csl
mtr bop ; stash csl value in operand

;; Apply caller's CSL to MCS register
mfr mcs ; read current mcs
rol	; preserve cmp
rol     ; preserve car
shl 3   ; zero out csl
rol     ; preserve psl
or      ; mask in caller's csl
mtr mcs ; write back mcs
mtr bop ; stash a copy of mcs (for loop start)

;; Get setup to start processing string
dec ptr ; point 1st gp back to string
inc psl ; use 2nd gp as loop counter
shl 6   ; zero out acc
shl 6
mtr ptr ; initialize counter to zero

;; Start reading & processing string chars

:loopbegin
mfr bop ; recall original mcs value
mtr mcs ; re-apply original mcs

;; Determine if this is an odd or even iteration
;; based on current counter value
shl 6   ; generate a bitmask for odd/even compare
shl 6
lol 1
mtr bop ; put odd/even bitmask in operand
mfr ptr ; get current counter
and     ; acc will be zero if even
eqz     ; mcs[cmp] is 1 if even

;; Read in a character
dec psl ; re-select string pointer (1st gp)
swr     ; read in a word
jcr X   ; jump to even block
:isodd


lda donechar
;; need to safely select nip again, UGH!!!
;; about ready to go back to standalone nip.

:iseven



:donechar



eq
eqz



jcr 5   ; escape the loop if done

;; need to safely select nip without losing csl
mfr mcs ; get mcs with caller's csl
mtr bop ; stash in bop
zsl     ; zero selector
dec psl ; select nip
lda loopbegin
mtr ptr ; goto start of loop 
nop

; jcr jumps here.







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

