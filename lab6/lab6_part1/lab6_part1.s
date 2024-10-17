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
/* r8   - Data from data register DATA field      DATA mask: 0x00FF       */
/* r9   - RVALID data from data register          RVALID mask: 0x8000     */
/* r10  - RAVAIL from data & WSPACE from control  both masks: 0xFFFF0000  */
/* r11  - AC data from controller register        AC mask: 0x400          */
/* r12  - Full data from UART data register                               */
/* r15  - UART Data register address                                      */
/**************************************************************************/

/*Tratamento da interrupção */ 
# 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F

POLLING_READ:
    ldwio r12, (r15)
    andi r9, r12, 0x8000
    beq r9, r0, POLLING_READ
    andi r8, r12, 0x00FF			/* the data is in the least significant byte */

POLLING_WRITE:
    ldwio r10, 4(r15)
    andhi r10, r10, 0xFFFF
    beq r10, r0, POLLING_WRITE
    stwio  r8, (r15)

br POLLING_READ
/*Configura as variaveis */
.global _start
_start:

movia r15, 0x10001000 /* Load controller address */

br POLLING_READ

.end

