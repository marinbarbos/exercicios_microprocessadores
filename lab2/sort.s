/*
João Pedro Brum Terra
João Vitor Figueredo
Marina Barbosa Américo

// vector ´e o vetor com os elementos a serem ordenados
// size ´e o tamanho do vetor
for (i=0; i < size; i++) {
    indice_max = i;
    for (j=i+1; j < size; j++) {
        if (vector[j] > vector[indice_max]) {
            indice_max = j;
        }
    }
    if (i != indice_max) { // se maior foi encontrado, troca
        temp = vector[indice_max];
        vector[indice_max] = vector[i];
        vector[i] = temp;
    }
}
 */

/*
r4 size do vetor
r5 ponteiro do vetor
r8 i
r9 j
r10 indice max
r11 temp1
 */

.equ	STACK, 0x10000

.global SORT
SORT:
   movi r8, 0 # i = 0
   
    FOR_EXTERNO:
        bgt r8, r4, FIM_SUB # if r8 > tam_vetor
        mov r10, r8
        addi r9, r8, 1

        FOR_INTERNO:
            bgt r9, r4, FIM_INTERNO # if r8 > tam_vetor

            add r11, r9, r9 # j*2
            add r11, r11, r11 # j*4
            add r11, r11, r5 # ponteiro vetor + j*4
            ldw r11, (r11) # vector[j]
            
            add r12, r10, r10 # indice_max*2
            add r12, r12, r12 # indice_max*4
            add r12, r12, r5 # ponteiro vetor + indice_max*4
            ldw r12, (r12) # vector[indice_max]
            
            ble r11, r12, NOT_TROCA # if (vector[j] > vector[indice_max]) 
            mov r10, r9 # indice_max = j;
            NOT_TROCA:
                addi r9, r9, 1 # i++
        br FOR_INTERNO
    FIM_INTERNO:
        beq r8, r10, NOT_TOCA2 # if (i != indice_max)
        
        add r11, r8, r8 # i*2
        add r11, r11, r11 # i*4
        add r11, r11, r5 # ponteiro vetor + i*4
        ldw r12, (r11) # t1 = vector[i]

        add r13, r10, r10 # indice_max*2
        add r13, r13, r13 # indice_max*4
        add r13, r13, r5 # ponteiro vetor + indice_max*4
        ldw r14, (r13) # t2 = vector[indice_max] 

        stw r14, (r11) # vector[indice_max] = t1;
        stw r12, (r13) # vector[i] = t2;

        NOT_TOCA2:
        addi r8, r8, 1 # i++
    br FOR_EXTERNO

FIM_SUB:
    br		FIM_SUB              /* Espera aqui quando o programa terminar  */


.end

