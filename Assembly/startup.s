:start
shl 6   ; zero put acc
shl 6
mtr mcs ; initialize mcs register
lol 7   ; load octal 7777 into acc
lol 7
lol 7
lol 7
mtr ptr ; initialize return stack ptr
shr 1   ; acc is now 3777
ror     ; acc is now 7377
inc psl ; increment psl to select data stack
mtr ptr ; initialize the data stack ptr

;; init console, keyboad, eeprom
;; decompress data to ram
;; skip over a bunch of library code
;; jump straight to main 

;; UPDATE: 2/16/2017 deciding against fixed stack sizes
;; and locations.  convention is up to rom developer.
;; stack size is easily computed by software without
;; even necessarily needing to store the initial address
;; just notting the pointer will give you most of the size.
;; up until the last value. This also frees up more pointers
;; for general use per the first design.

;; another approach would be to have two separate subs:
;; dstksz and rstksz .. might be less code and no arg expected!
        
:rstksz
zsl     ; zero out selectors
mfr ptr ; get return stack pointer
not     ; this only works for init addr 7777
dec acc ; dont include ourself to caller
mtr bop ; stash return val in operand
skr     ; pop return stack into acc
dec psl ; underflow to nip
mtr ptr ; jump to return address

:dstksz
zsl     ; zero out selectors
inc psl ; select data stack
mfr ptr ; get data stack pointer
mtr bop ; put into operand
lol 7   ; load original pointer constant
lol 3
lol 7
lol 7
sub     ; size = orig - current
mtr bop ; stash return val in operand
dec psl ; select return stack the easy way
skr     ; pop return stack into acc
dec psl ; select nip
mtr ptr ; jump to return address


