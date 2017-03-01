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

:example
zsl     ; zero selectors
inc psl ; select data stack
load myleetstr ; pretend second arg is ptr 1337 to string
skw     ; push second arg: ptr 1337
call strlen ; call subroutine
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
dec ptr ; may or may not be necessary
        ; i think the top of the stack is always empty

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

OFF BY 1 BUG: ZERO IS FIRST AND IS EVEN: FIX THIS

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
load loopbegin
mtr nip ; goto start of loop

mfr ptr ; jcr jumps here, get counter
mtr bop ; stash return value in bop
retn
