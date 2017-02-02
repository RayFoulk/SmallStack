


mult3:	skr		; read some value from rom or ram
		a2b		; copy value to operand
		shl 1	; multiply accumulator by 2
		add		; add operand to accumulator, result is value x 3
	
