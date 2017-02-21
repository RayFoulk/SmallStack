:start
shl 6   ; zero put acc
shl 6
mtr mcs ; initialize full mcs register to 0 
lol 7   ; load octal 7777 into acc
lol 7
lol 7
lol 7
mtr ptr ; initialize return stack ptr 7777
shr 1   ; acc is now 3777
ror     ; acc is now 7377
inc psl ; increment psl to select data stack
mtr ptr ; initialize the data stack ptr 7377

;; TODO:
;; init console, keyboad, eeprom
;; decompress all data to ram
;; skip over a bunch of library code
;; jump straight to main (no return)

;; UPDATE: 2/16/2017 deciding against fixed stack sizes
;; and locations.  convention is up to rom developer.
;; stack size is easily computed by software.
;; This approach also frees up more pointers
;; for general use.

;; Compute Return Stack Size
:rstksz
zsl     ; zero out selectors
mfr ptr ; get return stack pointer
not     ; this only works for init addr 7777
dec acc ; dont include ourself to caller
mtr bop ; stash return val in operand
skr     ; pop return stack into acc
mtr nip ; jump to return address

;; Compute Data Stack Size
:dstksz
zsl     ; zero out selectors
inc psl ; select data stack
mfr ptr ; get data stack pointer
mtr bop ; put into operand
lol 7   ; load original pointer constant
lol 3
lol 7
lol 7
zca     ; clear borrow
sub     ; size = orig - current
mtr bop ; stash return val in operand
dec psl ; select return stack
skr     ; pop return stack into acc
mtr nip ; jump to return address

