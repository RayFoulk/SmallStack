;; Original Instruction Set

start:  shr 6   ; zero out high char, will clear carry & compare
        oc0 0   ; set psel octet to return stack pointer
        oc1 1   ; set dsel octet to first ram bank
        a2c     ; initialize the mcs register
        oc0 7   ; load octal 7777 into accumulator
        oc1 7
        shl 6
        oc0 7
        oc1 7
        a2p     ; initialize the return stack pointer to 7777
        oc1 5   ; change accumulator to 7757
        shl 3   ; accumulator is now 7570
        oc0 7   ; accumulator is now 7577
        ips     ; increment psel to select data stack
        a2c     ; initialize the data stack pointer to 7577
        
        
        shl 6   ; zero out the accumulator
        shl 6
        a2b     ; zero out the operand register

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
        
        
        
