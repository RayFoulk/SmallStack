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
str "0mg 1337 h4x0r d00d"
:globalcount
u12 0
:bignum
u24 077777777
:signednum
i12 -01777 
:bigsignednum
i24 -017777777

:example
zsl     ; zero selectors
inc psl ; select data stack
lda myleetstr ; pretend second arg is ptr 1337 to string
skw     ; push second arg: ptr 1337
dec psl ; select return stack

;; This opcode sequence could be aliased
;; to a "call" mnemonic
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
inc psl ; select gp addr reg p2
mtr ptr ; store stack ptr in p2

;; Get setup to start processing string
inc psl ; use p3 as loop counter
shl 6   ; zero out acc
shl 6
mtr ptr ; initialize counter to zero
lol 1   ; acc already zero, create bitmask for odd/even compare
mtr bop ; put odd/even bitmask in operand

;; Start reading & processing string chars
:loopbegin

;; Determine if this is an odd or even iteration
;; based on current counter value
mfr ptr ; get current counter
xor     ; acc will be zero if even
eqz     ; mcs[cmp] will be 1 if odd

;; Read in a character
dec psl ; re-select string pointer p2
swr     ; read in a word

jcr 2   ; skip over next two ops if odd
shl 6   ; even only, put low char in high
inc ptr ; even only, advance to next word
shr 6   ; bring high char down to low
        ; character is place either way here
eqz     ; check for null terminator
jcr 7   ; escape the loop if done, skip next 7 ops

inc psl ; back up to the counter
inc ptr ; counter++
lda loopbegin
mtr nip ; goto start of loop

mfr ptr ; jcr jumps here, get counter
mtr bop ; stash return value in bop

:doreturn
zsl     ; zero selectors to return stack
skr     ; pop return stack to acc
mtr nip ; jump to return address
