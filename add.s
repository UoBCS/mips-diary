        .data
        .align 2

vara:   .word 5
varb:   .word 7

        .text
        .globl main

main:
        lw $8,vara
        lw $9,varb
        add $8,$8,$9
        sw $8,vara

        li $2,10
        syscall
