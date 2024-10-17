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

/*Tratamento da interrupção */    
    .org 0x20
RTI:
    rdctl et, ipending
    beq et, r0, OTHER_EXCEPTIONS
    subi ea, ea, 4
    
    andi r9, et, 2
    beq r9, r0, OTHER_EXCEPTIONS
    call EXT_IRQ1

OTHER_EXCEPTIONS:
    eret
/*Sub Rotina - de somador */
    .org 0x100
EXT_IRQ1:
    ldwio r11, 0(r12)
    add r14, r14, r11

    stwio r14, 0(r13)
    ret

/*Configura as variaveis */
.global _start
_start:

mov r9, r0/*Variable that load the id of interuption */
mov r11,r0/*Variable that load the value from slide switchs */
mov r14,r0/*Variable that acumulates the total */
movia r12, 0x10000040/*Load the adress of slide switchs */
movia r13, 0x10000010/*Load the adress of greenleds */
movia r15, 0x10000050/*Load the the edge bits */
movi r8, 0x2
stwio r8, 8(r15)

wrctl ienable, r8 /*Enable pushbutton 1 */ 

movia r8, 1
wrctl status, r8 

LACO:
  br LACO

.end