/*
João Pedro Brum Terra
João Vitor Figueredo
Marina Barbosa Américo
*/  

/*
1. zerar buffer CR CR <- 1 dps CR <- 0
2. amostras = 0
3. while amostras < 96000*3
3.1. while (RALC == 0 && RARC == 0) { NOP }
3.2. left_samples[amostras] = left_data)
3.3. right_samples[amostras] = right_data
3.4. amostras++
3.5. voltar para 3.
*/

/**************************************************************************/
/* Playback Program                                                       */
/*  Reproduz os dados da memoria na porta de audio.                       */
/*                                                                        */
/* r8   - ONE 1                                                           */
/* r9   - RVALID data from data register          RVALID mask: 0x8000     */
/* r10  - RAVAIL from data & WSPACE from control  RAVAIL mask: 0xFFFF0000 */
/* r11  - AC data from controller register        AC mask: 0x400          */
/* r12  - no idea tbh                                                     */
/* r13  - aaaaaaaaaaaaaaaa                                                */
/* r14  - CW register                                                     */
/* r15  - Audio Control Register address                                  */
/**************************************************************************/
.equ SAMPLE_RATE, 0x119400
/*Configura as variaveis */
.global PLAYBACK
PLAYBACK:

movia r8, 1
mov r14, r0
movia r15, 0x10003040 /* Load control register address */

#  mask 0x4 for CW register
ldwio r14, 0(r15)
andi r14, r14, 0x8
stw r8, 3(r14)
stw r0, 3(r14)

ret