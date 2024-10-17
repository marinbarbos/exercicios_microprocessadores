/* 
entrada: n numeros de fibonacci,
saida: FIB array de fibonacci
*/

.equ FIB, 0x1000	  /* Starting address of the list		    */
.equ NUM, 0xFFC

.global _start
_start:
	movia	r9, NUM	  /* r4 points to the start of the list	    */
    ldw r10, (r9)   /* r10 = N */
    addi r9, r9, 4 /* r9 = FIB */

    stw r0, (r9)  /* fib[0] = 0 */

    movi r11, 1
    #addi r9, r9, 4 /* r9 = FIB */
    #stw r11, (r9)
    stw r11, 4(r9)  /* fib[1] = 1 */

    movi r8, 3 /* i = terceira pos no array */

LOOP:
	bge	r8, r10, STOP  /* Finished if r8 is equal to 0		    */

    ldw r11, (r9) /* valor anterior */
    ldw r12, 4(r9) /* valor atual */

    add r13, r11, r12
    addi r9, r9, 4 /* incrementa r9, segue a lista */
    stw r13, 4(r9)
    addi r8, r8, 1 /* i++ */

	br	LOOP

STOP:	
	br	STOP		  /* Remain here if done			    */

.org	0xFFC
N:
.word 8			  /* Number of fibonaccies in the list		    */

.end
