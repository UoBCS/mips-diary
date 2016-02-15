        .data
        .align 2

vara:   .word 0
varb:   .word 4
varc:   .word 2
vard:   .word 7

        .text
        .globl main

main:
        lw $8,varb
        lw $9,varc
        lw $10,vard
        add $11,$8,$9
        sub $12,$11,$10
        sw $12,vara

        li $2,10
        syscall
