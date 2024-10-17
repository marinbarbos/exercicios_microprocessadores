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
# 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F

ARR_DISPLAY:
    .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x5f, 0x77, 0x7F, 0x39, 0x3F, 0x79, 0x71
    
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
    movia r12, 0x10000040/*Load the adress of slide switchs */
    ldwio r11, 0(r12)
    add r14, r14, r11
    
    movia r13, 0x10000010/*Load the adress of greenleds */
    stwio r14, 0(r13)

    # PRIMEIRO DISPLAY
    movia r13, ARR_DISPLAY
    andi r12, r14, 0x0F
    add r13, r13, r12
    ldb r13, (r13)
    stbio r13, (r10)

    # SEGUNDO DISPLAY
    movia r13, ARR_DISPLAY
    srli r12, r14, 4
    andi r12, r12, 0x0F
    add r13, r13, r12
    ldb r13, (r13)
    stbio r13, 1(r10)

    # TERCEIRO DISPLAY
    movia r13, ARR_DISPLAY
    srli r12, r14, 8
    andi r12, r12, 0x0F
    add r13, r13, r12
    ldb r13, (r13)
    stbio r13, 2(r10)

    # QUARTO DISPLAY
    movia r13, ARR_DISPLAY
    srli r12, r14, 12
    andi r12, r12, 0x0F
    add r13, r13, r12
    ldb r13, (r13)
    stbio r13, 3(r10)    

    stwio r0, 12(r15)
    ret

/*Configura as variaveis */
.global _start
_start:

mov r9, r0/*Variable that load the id of interuption */
mov r11,r0/*Variable that load the value from slide switchs */
mov r14,r0/*Variable that acumulates the total */
movia r10, 0x10000020 /* Load 7 segments display address */

# movia rxx, 0x10000020 /* Load 7 segments display address */
movia r15, 0x10000050/*Load the the edge bits */
movi r8, 0x6
stwio r8, 8(r15)

wrctl ienable, r8 /*Enable pushbutton 1 */ 

movia r8, 1
wrctl status, r8 

LACO:
  br LACO

.end

