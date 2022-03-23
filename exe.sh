#!/bin/bash
#Script para geração de analisador sintático
echo "Iniciando o BISON"
bison -d fonte.y
echo "Criando Arquivo de Estados da Linguagem"
bison -rstates fonte.y
echo "Renomeando arquivos"
mv fonte.tab.h analisador.h
mv fonte.tab.c comp.y.c
echo "Iniciando FLEX"
flex fonte.l
echo "Renomeando arquivos"
mv lex.yy.c comp.flex.c
echo "Compilando arquivos"
gcc -c comp.flex.c -o comp.flex.o
gcc -c comp.y.c -o comp.y.o
gcc -o comp comp.flex.o comp.y.o -lfl -lm
echo "Para executar o compilador digite: ./comp [nome do arquivo a ser testado]"
