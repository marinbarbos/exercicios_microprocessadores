/*
João Pedro Brum Terra
João Vitor Figueredo
Marina Barbosa Américo
*/

.equ TEST_NUM, 0x7cf		/* The number to be tested */
.equ ONE, 0x01
/**************************************************************************/
/* Main Program                                                           */
/*   Determines the maximum number of consecutive 1s in a data word.      */
/*                                                                        */
/* r8   - Contains the test data                                          */
/* r9   - Holds the data as it is being tested                            */
/* r10  - current counter                                                 */
/* r11  - andded r9 with 0x01                                             */
/* r12  - max counter                                                     */
/* r13  - 0x01                                                            */
/**************************************************************************/

.global _start
_start:
	movia	r8, TEST_NUM		/* Load r8 with the number to be tested */
	mov	r9, r8			/* Copy the number to r9 */
    movia r13, ONE
    mov r12, r0
	
STRING_COUNTER:
	mov	r10, r0			/* Clear the counter to zero */
STRING_COUNTER_LOOP:				
	# beq	r9, r0, UPDATE_RESULT  /* Loop until r9 contains no more 1s   */
	beq	r9, r0, FIM_LACO  /* Loop until r9 contains no more 1s   */

    and	r11, r9, r13			/*    AND r09 with 0x01 check if first bit is 0    */
    bne r11, r0, ADD_COUNTER 

	srli	r9, r9, 0x01		/* Throw first 1 to the void */

    bgt r10, r12, UPDATE_RESULT
    mov r10, r0
    br STRING_COUNTER_LOOP

ADD_COUNTER:
	srli	r9, r9, 0x01		/* Throw first 1 to the void */
	addi	r10, r10, 0x01		/* Increment local counter */
	br	STRING_COUNTER_LOOP

UPDATE_RESULT:
    mov r12, r10
    mov r10, r0
    # bgt r9, r0, STRING_COUNTER_LOOP
    br STRING_COUNTER_LOOP

FIM_LACO:
    movi r10, 0xFFFFFFFF
    bne r8, r10, END
    movi r12, 32

END:
	br	END				/* Wait here when the program has completed */
.end
