;; Note: Manually selecting the return stack pointer
;; may not always be necessary depending on context,
;; but putting things in a known state will work in
;; all cases.

:subrtna
mfr mcs ; get current mcs
rol     ; preserve cmp
lol 0   ; clear car
lol 1   ; csl ram bank 1
lol 1   ; psl data stack
mtr mcs ; write back new mcs
:pushargs
...     ; push all arguments to data stack
...
skw
...
...
:pushaddr
dec psl ; select return stack the easy way
shl 6   ; zero out acc
shl 6
lol 4   ; load nip offset (+4 words) in acc
mtr bop ; put nip offset into operand
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
:doreturn
mfr mcs ; get mcs register
rol     ; preserve cmp
rol     ; preserve car
lol 1   ; select ram bank 1
lol 0   ; select return stack
mtr mcs ; configure mcs register
skr     ; pop return stack
mtr nip ; jump to return address

