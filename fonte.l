%{
    #include <stdio.h>
    #include "analisador.h"
    
    int erros = 0;
    int linhas = 1;
%}

DIGITO [0-9]
ALFABETO [a-zA-Z]
ESPACO " "|"\t"

MAIN "main"

IF "if"
ELSE "else"
FOR "for"
WHILE "while"
DO "do"
PRINTF "printf"
RETURN "return"

ASPAS "'"
ABRE_PARENTESIS "("
FECHA_PARENTESIS ")"
ABRE_CHAVE "{"
FECHA_CHAVE "}"
SEPARADOR ";"
VIRGULA ","

OPERADOR  "+"|"-"|"*"|"/"|"^"
MAIOR_MENOR "<"|">"
IGUAL "="
PONTUACAO "!"|"?"

QUEBRA_LINHA [\n]

%%

{MAIN} { return (MAIN);}//Token Main

"int"|"float"|"double"|"bool"|"void"|"long int" { return (TIPO);}//Tokens de tipos de variaveis possiveis

{IF} { return (IF);}//Token da função de Caso IF
{ELSE} { return (ELSE);}//Token da função de Caso Else
{FOR} { return (FOR);}//Token da função do laço For
{WHILE} { return (WHILE);}//Token da função  do laço While
{DO} { return (DO);}//Token da função do laço Do
{PRINTF} { return (PRINTF);}//Token da função Printf
{RETURN} { return (RETURN);}//Token da função Return

{ASPAS} { return (ASPAS);}//Token de aspa simples para escrita no print
{ABRE_PARENTESIS} { return (ABRE_PARENTESIS);}//Token de Abre Parentesis (
{FECHA_PARENTESIS} { return (FECHA_PARENTESIS);}//Token de Fecha Parentesis )
{ABRE_CHAVE} { return (ABRE_CHAVE);}//Token de Abre Chave 
{FECHA_CHAVE} { return (FECHA_CHAVE);}//Token de Fecha Chave 
{SEPARADOR} { return (SEPARADOR);}//Token de separador ;
{VIRGULA} { return (VIRGULA);}//Token de virgula ,

{ALFABETO}+({ALFABETO}|{DIGITO})* { return IDENTIFICADOR; }//Token de váriaveis/palavras
{DIGITO}+ { return (INTEIRO);}//Token de números inteiros
{DIGITO}{DIGITO}*"."{DIGITO}{DIGITO}* { return (REAL);}//Token de números reais
{PONTUACAO} { return (PONTUACAO);}//Token de pontuação
"%"{ALFABETO}+({ALFABETO}|{DIGITO})* { return CITACAO; }//Token de citação de uma variavel dentro do printf

{ESPACO}+ {}//Espaço

{OPERADOR} { return (OPERADOR);}//Token de operadores matemáticos (+, /, -, *)
"+""+"|"-""-" { return (ITERACAO);}//Token de operação matematica de iteracao (++, --)
{IGUAL} { return (IGUAL);}//Token do sinal de igual =
{IGUAL}{IGUAL}|"!"{IGUAL} { return (COMP);}//Token de comparação igual ou diferente (==, !=)
{MAIOR_MENOR}|{MAIOR_MENOR}{IGUAL}  { return (MAIOR_MENOR);}//Token de comparação maior, menor, etc (>, <, >=, <=)

{QUEBRA_LINHA} {linhas++;} //Quebra de linha e aumenta o contador, para sabermos onde estamos no arquivo de entrada           

"//".*$ {}

%%
int yywrap();
int main_lex() {
  yylex();
  printf("Total de erros encontrados: %d\n", erros);
  if(erros==0)
    puts("\nCódigo analisado com sucesso!\n");
}

int yywrap() {
  return 1;
}

