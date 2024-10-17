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
/* Record Program                                                         */
/*  Grava os dados da porta de audio na memoria por tres(3) segundos.     */
/*                                                                        */
/* r8   - ONE 1                                                           */
/* r9   - RVALID data from data register          RVALID mask: 0x8000     */
/* r10  - RAVAIL from data & WSPACE from control  RAVAIL mask: 0xFFFF0000 */
/* r11  - AC data from controller register        AC mask: 0x400          */
/* r12  - FifoSpace register address                                      */
/* r13  - amostras                                                        */
/* r14  - CR register                                                     */
/* r15  - Audio Control Register address                                  */
/**************************************************************************/
.equ SAMPLE_RATE, 0x119400
/*Configura as variaveis */
.global RECORD
RECORD:

movia r12, 0x10003044 /* Load control register address */
mov r13, r0 # amostras = 0
mov r14, r0
movia r15, 0x10003040 /* Load control register address */
#  Zeroes CR
#  mask 0x4 for CR register
ldwio r14, 0(r15)
andi r14, r14, 0x4
stwio r14, (r15)
stwio r0, (r15)

SAMPLING_LOOP:
    movia r12, SAMPLE_RATE
    bgt r13, r12, RET_END

    movia r12, 0x10003044 /* Load control register address */
FIFO_POLLING:
    ldwio r14, (r12)
    andi  r14, r14, 0xFFFFF
    beq r12, r0, FIFO_POLLING

    movia r8, 0x10003048
    movia r10, LEFT_SAMPLES
    ldwio r9, (r8)
    slli  r11, r13, 2      # r13*4
    add   r10, r10, r11    # left_samples[amostras]
    stw   r9, (r10)

    movia r8, 0x1000304C
    movia r10, RIGHT_SAMPLES
    ldwio r9, (r8)
    slli  r11, r13, 2      # r13*4
    add   r10, r10, r11    # left_samples[amostras]
    stw   r9, (r10)
    addi  r13, r13, 1

    br FIFO_POLLING



    

LEFT_SAMPLES:
    .skip SAMPLE_RATE

RIGHT_SAMPLES:
    .skip SAMPLE_RATE


RET_END:
    ret
