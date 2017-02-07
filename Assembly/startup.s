;; Revised Instruction Set

start:  shl 6   ; pull up zero char for clearing carry & compare
        lol 0   ; set psel octet to return stack pointer
        lol 1   ; set dsel octet to first ram bank
        mtx mcs ; initialize the mcs register
        lol 7   ; load octal 7777 into accumulator
        lol 7
        lol 7
        lol 7
        mtx ptr ; initialize the return stack pointer to 7777
        lol 5   ; change accumulator to 7775
        rol     ; accumulator is now 7757
        rol     ; accumulator is now 7577
        inc psel ; increment psel to select data stack
        mtx mcs ; initialize the data stack pointer to 7577

;; NOTE: with proper reset, the stack pointers could be initialized
;; / pre-loaded automatically -- choose constants wisely!        
        return stack grows downward toward data stack
        with initial data stack ptr 7577 this means
            decimal 128 entries for return stack (7 bit size)
        with 7377 it becomes decimal 256 (8 bit size)

