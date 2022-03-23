%{
#include "analisador.h"
#include <stdio.h>
#include <stdlib.h>
extern int linhas;
extern int erros;
%}

%token TIPO MAIN //Tipo de variaveis/funções

%token IF ELSE FOR WHILE DO PRINTF RETURN //Funções

%token ASPAS ABRE_PARENTESIS FECHA_PARENTESIS ABRE_CHAVE FECHA_CHAVE SEPARADOR VIRGULA //Caracteres reservados

%token OPERADOR COMP IGUAL MAIOR_MENOR ITERACAO //Operadores matemáticos e de comparação

%token IDENTIFICADOR INTEIRO REAL PONTUACAO CITACAO//Tipos de variaveis, números, pontuações e citações de variaveis

%start Programa //Execução da cadeia de saída
%%

//programa principal
Programa: Declara_Funcao MAIN ABRE_PARENTESIS FECHA_PARENTESIS Chaves_R Escreve_Funcao|error{yyerror("", linhas);};
//Declarar uma função no programa
Declara_Funcao: TIPO IDENTIFICADOR ABRE_PARENTESIS Lista_Var_F FECHA_PARENTESIS SEPARADOR Declara_Funcao | ;
//Listar as variaveis de parametro dentro de uma função
Lista_Var_F: TIPO IDENTIFICADOR VIRGULA Lista_Var_F | TIPO IDENTIFICADOR | ;
//Abre e Fecha de chaves com os comandos dentro, com e sem retornar.
Chaves: ABRE_CHAVE Comandos FECHA_CHAVE;
Chaves_R: ABRE_CHAVE Comandos Retornar FECHA_CHAVE;
//Comandos dentro do programa possíveis
Comandos: Comando Comandos |;
//Declaração de variaveis, atribuição de valor em variaveis, printar algum texto, Caso de IF/Else, Laços de Repetição, Funções 
Comando: Declaracao SEPARADOR| Atribuicao SEPARADOR| Print SEPARADOR| Caso | Laco | Funcao SEPARADOR | error {yyerror("",linhas);};
//Declaração de variaveis
Declaracao: TIPO Lista_Var;
//Listagem das variaveis que serão criadas
Lista_Var: IDENTIFICADOR Atribui_valor;
//Atribuição de valores nas variaveis que estão sendo criadas
Atribui_valor: IGUAL Valor VIRGULA Lista_Var| IGUAL Valor | VIRGULA Lista_Var |;
//Valores possiveis: Váriavel ou Número(Real ou Inteiro)
Valor: IDENTIFICADOR | Num | Funcao ;
Num: INTEIRO | REAL ;
//Chamativa de função
Funcao: IDENTIFICADOR ABRE_PARENTESIS Variaveis FECHA_PARENTESIS;
//Passagem de variaveis paramentros dentro de chamadas de funções
Variaveis: Valor VIRGULA Variaveis | Valor | ;
//Atribuir a uma variavel o resultado de uma operação matematica, de um valor de variavel, número ou função, ou adicionar ou remover 1
Atribuicao: IDENTIFICADOR IGUAL OpMat | IDENTIFICADOR IGUAL Valor |IDENTIFICADOR ITERACAO;
//Operações matematicas feitas com Valor
OpMat: ABRE_PARENTESIS Valor OpMat_P FECHA_PARENTESIS | Valor OpMat_P;
OpMat_P: OPERADOR OpMat | OPERADOR Valor;
//Printf do programa
Print: PRINTF ABRE_PARENTESIS Sentenca FECHA_PARENTESIS;
//Sentença dentro do parentesis do printf
Sentenca: ASPAS Palavra ASPAS Citar Sentenca | ;
//Palavras possiveis para escrever no printf. Pondendo ser Variaveis, Numeros, Virgulas, Pontuações e Citar tipo de váriavel
Palavra: Valor Palavra | PONTUACAO Palavra | VIRGULA Palavra | CITACAO Palavra |;
//Definir qual variavel está sendo citada no printf
Citar: VIRGULA IDENTIFICADOR | VIRGULA IDENTIFICADOR VIRGULA |;
//Caso IF de comparação
Caso: IF ABRE_PARENTESIS Valor Comparacao Valor FECHA_PARENTESIS Chaves Caso_Else;
//Comparação entre valores, como maior ou igual, menor, diferente, etc
Comparacao: COMP | MAIOR_MENOR;
//Caso Else, que vem somente apos um if
Caso_Else: ELSE Chaves | ;
//Criação de Laços de Repetição
Laco: While_L | Do_L | For_L;
//Laço Do While
Do_L: DO Chaves While_D SEPARADOR;
//Criação de While, tanto para um laço While quanto Do...While
While_D: WHILE ABRE_PARENTESIS IDENTIFICADOR Comparacao Valor FECHA_PARENTESIS ;
//Laço While
While_L: While_D Chaves;
//Laço FOr
For_L: FOR ABRE_PARENTESIS TIPO IDENTIFICADOR IGUAL Valor SEPARADOR IDENTIFICADOR MAIOR_MENOR Valor SEPARADOR IDENTIFICADOR ITERACAO FECHA_PARENTESIS Chaves;
//Return de funções e da main
Retornar: RETURN Valor SEPARADOR | RETURN SEPARADOR |;
//Escrita de uma função, com seus comandos,definições, etc
Escreve_Funcao: TIPO IDENTIFICADOR ABRE_PARENTESIS Lista_Var_F FECHA_PARENTESIS Chaves_R Escreve_Funcao | ;

%%
FILE *yyin;

int yyerror(char *str, int num_linha) {//Função de erro dentro do arquivo de entrada
  if(strcmp(str,"syntax error")==0){
    erros++;
    printf("Erro sintático\n");//Exibe mensagem de erro
  }
  else{
    printf("O erro aparece próximo à linha %d\n",num_linha);//Exibe a linha do erro
  }
  return erros;
}

main (int argc, char **argv ){//Main, percorre o arquivo de entrada
  ++argv, --argc; //desconsidera o nome do programa
  if ( argc > 0 )
    yyin = fopen( argv[0], "r" );
  else{
    puts("Falha ao abrir arquivo, nome incorreto ou não especificado. Digite o comando novamente."); //exibe mensagem de texto se o arquivo não for especificado ou for especificado com o nome errado
    exit(0);
  }
  do {
    yyparse();
  }while (!feof(yyin));//enquanto não chegar ao fim do arquivo faz as análises
  if(erros==0)//Não tendo erros, imprime mensagem de fim de análise com sucesso
    puts("Análise concluída com sucesso");
  else{//Tendo erros na execução mostra está mensagem invez
    puts("Análise com erros");
    printf("Total de erros encontrados: %d\n", erros);
  }
}
