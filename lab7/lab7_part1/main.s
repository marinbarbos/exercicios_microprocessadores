/*
João Pedro Brum Terra
João Vitor Figueredo
Marina Barbosa Américo
*/  

/*
96KHz * 3 segundos * 4 bytes = qtd amostras

while(1)
    if key1 -> record()
    elif key2 -> playback()

records:
    records
playback:
    playsback
 
*/


/**************************************************************************/
/* Main Program                                                           */
/*  Le os dados da porta de audio e armazena eles na memoria quando o     */
/*  usuario pressionar o botao KEY1. A gravacao deve ser reproduzida      */
/*  na porta de audio quando o usuario pressionar o botao KEY2.           */
/*  Por polling                                                           */
/*                                                                        */
/* r8   - Data from data register DATA field      DATA mask: 0xFF         */
/* r9   - RVALID data from data register          RVALID mask: 0x8000     */
/* r10  - RAVAIL from data & WSPACE from control  RAVAIL mask: 0xFFFF0000 */
/* r11  - AC data from controller register        AC mask: 0x400          */
/* r12  - no idea tbh                                                     */
/* r13  - aaaaaaaaaaaaaaaa                                                */
/* r14  - Timer address                                                   */
/* r15  - Contains Push Button data                                       */
/**************************************************************************/
.equ SAMPLE_RATE, 0x119400

/*Configura as variaveis */
.global _start
_start:

movia r15, 0x1000005C /* Load control register address */

movia r11, 0x10000010 # stores address into r11 for use 

POLLING:
    ldwio r13, 0(r15)
    andi r14, r13, 0x2
    bne r14, r0, CALL_REC # if KEY1 == pressed RECORD
    # ldwio r13, 0(r15)
    andi r13, r13, 0x4
    bne r13, r0, CALL_PLAY # if KEY2 == pressed PLAYBACK
    br POLLING #  loop de loop

CALL_REC:
    stwio r0, 0(r15)
    call RECORD
    br POLLING
    
CALL_PLAY:
    stwio r0, 0(r15)
    call PLAYBACK
    br POLLING

END:
	br	END				/* Wait here when the program has completed */
.end
