;; Revised Instruction Set

start:  shl 6   ; pull up zero char for clearing carry & compare
        lol 0   ; set psel octet to return stack pointer
        lol 1   ; set dsel octet to first ram bank
        mtr mcs ; initialize the mcs register
        lol 7   ; load octal 7777 into accumulator
        lol 7
        lol 7
        lol 7
        mtr ptr ; initialize the return stack pointer to 7777
        lol 5   ; change accumulator to 7775
        rol     ; accumulator is now 7757
        rol     ; accumulator is now 7577
        inc psel ; increment psel to select data stack
        mtx mcs ; initialize the data stack pointer to 7577

;; NOTE: with proper reset, the stack pointers could be initialized
;; / pre-loaded automatically -- choose constants wisely!        
;;      return stack grows downward toward data stack
;;      with initial data stack ptr 7577 this means
;;          decimal 128 entries for return stack (7 bit size)
;;      with 7377 it becomes decimal 256 (8 bit size)

;; UPDATE: 2/16/2017 deciding against this approach
;; stack size is easily computed by software without
;; even necessarily needing to store the initial address
;; just notting the pointer will give you most of the size.
;; up until the last value. This also frees up more pointers
;; for general use per the first design.

;; this assumes design 1 for ptr reg bank
;; also assumes that stacks are stored in ram bank 1
;; makes a few loose assumptions about where stacks
;; are located in memory.
;; the data stack size is not checked here, but
;; it is assumed to contain the stack of the size to check!
;; maybe this is a bad approach, and for this function
;; only adopt a different calling convention.

stksz:  mfr mcs  ; get current mcs
        ror      ; prepare to discard current psel
        ror      ; prepare to discard current dsel
        lol 1    ; dsel ram bank 1
        lol 1    ; psel data stack
        mtr mcs  ; data stack is selected.
        mfr ptr  ; get the data stack pointer
        inc psel ; psel++ to gp addr ptr
        mtr ptr  ; put the data stack ptr into gp addr reg
        skr      ; get the value at the top of the data stack.
        eqz      ; if zero then return stack, otherwise data stack.
        jcp ...


;; another approach would be to have two separate subs:
;; dstksz and rstksz .. might be less code and no arg expected!
        

 
     
shl 6   ; pull up zero char for clearing carry & compare

