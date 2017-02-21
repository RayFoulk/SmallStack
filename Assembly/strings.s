;; Calling convention: arguments are expected on the
;; data stack.  caller pushes and pops.  callee just
;; references, but may also push multiple return
;; values.  Integer return codes are placed in bop.

;; TODO: Implementation may or may not just assume
;; that data is in RAM 0.  If not, then every routine
;; will need to have a chip ID as the first argument.
;; This will consume a lot of code space.

;; Making the assumption that data is in RAM 0 makes
;; implementation easier, but will also depend on
;; ALL data being relocated from ROM to RAM at startup.
;; If this is to be the case, then compression &
;; decompression routines will also have to be developed.

;; These implementations assume all data is in RAM 0,
;; And also that data locations can be labelled by the
;; assembler.

;; (Decompressed Data Section)
:myleetstr
"0mg 1337 h4x0r d00d"

:example
zsl     ; zero selectors
inc psl ; select data stack
lda myleetstr ; pretend second arg is ptr 1337 to string
skw     ; push second arg: ptr 1337
dec psl ; select return stack
shl 6   ; zero out acc
shl 6
lol 4   ; load nip offset (+4 words) in acc
mtr bop ; put nip offset into operand
zca     ; clear carry
mfr nip ; get nip into accumulator
add     ; add nip offset into accumulator
skw     ; push return address to stack
lda strlen
mtr nip ; jump to subroutine
nop     ; because of word alignment
mfr bop ; returns to here, get str len into acc
nop
nop
nop
nop
nop
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
inc psl ; select data stack
mfr ptr ; get data stack ptr
inc psl ; select gp addr reg
mtr ptr ; store stack ptr



;; TODO: Finish this



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

