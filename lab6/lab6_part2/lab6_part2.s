/*
João Pedro Brum Terra
João Vitor Figueredo
Marina Barbosa Américo
*/  


/**************************************************************************/
/* Main Program                                                           */
/*   Escreva um programa que implementa uma tarefa do estilo “maquina     */
/*   de escrever”; ou seja, leia cada caracter que e recebido pela JTAG   */
/*   UART a partir do computador hospedeiro e entao mostre o caracter     */
/*   na janela do terminal do programa monitor. Use a tecnica de polling  */
/*   para determinar se um novo caracter esta disponıvel na JTAG UART.    */
/*                                                                        */
/* r8   - Data from data register DATA field      DATA mask: 0xFF         */
/* r9   - RVALID data from data register          RVALID mask: 0x8000     */
/* r10  - RAVAIL from data & WSPACE from control  RAVAIL mask: 0xFFFF0000 */
/* r11  - AC data from controller register        AC mask: 0x400          */
/* r12  - no idea tbh                                                     */
/* r13  - aaaaaaaaaaaaaaaa                                                */
/* r14  - Timer address                                                   */
/* r15  - UART Data register address                                      */
/**************************************************************************/

/*Tratamento da interrupção */ 
# 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F

    .org 0x20
RTI:
    rdctl et, ipending
    beq et, r0, OTHER_EXCEPTIONS

    subi ea, ea, 4    
    andi r12, et, 1
    beq r12, r0, OTHER_EXCEPTIONS
    call TIMER_EXEC

OTHER_EXCEPTIONS:
    eret

TIMER_EXEC:
movia r14, 0x10002000
stwio r0, (r14)
stwio  r13, (r15)

ret

/*Configura as variaveis */
.global _start
_start:

movia r15, 0x10001000 /* Load controller address */

/* Start timer interrupt config */
movia r14, 0x10002000

movia r8, 25000000 /* half second */
stwio r8, 8(r14) /* lower counter part */

srli r10, r8, 16 /* higher counter part */
stwio r10, 12(r14) 

movi r11, 0b111
stwio r11, 4(r14) /* init timer */

movi r14, 1  /* timer IRQ is 0 */
wrctl ienable, r14 /*Enable timer */ 

/* idk what is this tbh */
movia r8, 1
wrctl status, r8 



POLL_READ:
    ldwio r12, (r15)
    andi r9, r12, 0x8000
    beq r9, r0, POLL_READ
    andi r13, r12, 0x00FF			/* the data is in the least significant byte */
    
POLLING_WRITE:
    ldwio r10, 4(r15)
    andhi r10, r10, 0xFFFF
    beq r10, r0, POLLING_WRITE
    stwio  r13, (r15)
    br POLL_READ

.end

