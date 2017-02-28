;; Making the assumption that data is in RAM 0 makes
;; implementation easier, but will also depend on
;; ALL data being relocated from ROM to RAM at startup.
;; If this is to be the case, then compression &
;; decompression routines will also have to be developed.

;; These implementations assume all data is in RAM 0,
;; And also that data locations can be labelled by the
;; assembler.  The examples below are enough to create
;; primitive data structures

;; (Decompressed Data Section)
:myleetstr
str "Hello, World"
:globalcount
u12 0
:bignum
u24 077777777
:signednum
i12 -01777 
:bigsignednum
i24 -017777777
