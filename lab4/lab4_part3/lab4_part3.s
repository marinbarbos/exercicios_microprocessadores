/*
João Pedro Brum Terra
João Vitor Figueredo
Marina Barbosa Américo
*/

/**************************************************************************/
/* Main Program                                                           */
/*   Determines the maximum number of consecutive 1s in a data word.      */
/*                                                                        */
/* r8   - Contains the switch data                                        */
/* r9   - Switch data sum                                                 */
/* r10  - Slide switch address for use                                    */
/* r11  - Green LED address for use                                       */
/* r12  - Push Button address for use                                     */
/* r13  - Contains Push Button data                                       */
/**************************************************************************/

.global _start
_start:
     # ldwio load to register wihout cache 
    # 0x10000010 - 0x1000001F Green LED
    # 0x10000040 - 0x1000004F Slide switch
    # 0x10000050 - 0x1000005F Push Button
    mov r9, r0 # sets r9 to 0
    mov r8, r0 # sets r8 to 0
    movia r10, 0x10000040 # stores address into r10 for use 
    movia r11, 0x10000010 # stores address into r11 for use 
    movia r12, 0x1000005C # stores address into r12 for use 
    movia r15, 0x10000000 # stores address into r15 for use 
    mov r14, r0

POLLING:
    ldwio r13, 0(r12)
    andi r13, r13, 0x4 # pick key2
    bne r13, r0, POLLING_MULT # if not 0 then probably 1
    ldwio r13, 0(r12)
    andi r13, r13, 0x2 # pick key1
    beq r13, r0, POLLING
    stwio r0, 0(r12)
    br LOOP
POLLING_MULT:
    srli r14, r14, 2
    stwio r15, 0(r14)
    br POLLING
LOOP:
    ldwio r8, 0(r10) # loads slide switch value into r8
    andi  r8, r8, 0xff
    add r9, r9, r8   # accumulates r8 value into r9
    slli r14, r14, 8 # shift the media result
    or r14, r14, r8
    stwio r9, 0(r11) # shows r9 value in green LEDs
    br POLLING # loops to loop
END:
	br	END				/* Wait here when the program has completed */
.end