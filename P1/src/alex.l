%{
    #include <stdio.h>
    #include <string.h>
    #include "header.h"

    #define retornar(x) {if (verbosidad) ECHO;}
%}

%option noinput
%option nounput

%option yylineno

delimitador [ \t\n]+
digito [0-9]
entero {digito}+

%%

{delimitador} {if (verbosidad) ECHO ; }
"+" { retornar (MAS_) ; }
"-" { retornar (MENOS_) ; }
"*" { retornar (POR_) ; }
"/" { retornar (DIV_) ; }
"(" { retornar (OPAR_) ; }
")" { retornar (DIV_) ; }
{entero} { retornar (CTE_) ; }
. { yyerror("Caracter desconocido") ;}

%%

int verbosidad = FALSE;

void yyerror(const char *msg){
    /* Tratamiento de errores. */
    fprintf(stderr, "\nError en la linea %d: %s\n", yylineno, msg);
}

int main(int argc, char **argv) {
    int i, n=1 ;
    for (i=1; i<argc; ++i)
    if (strcmp(argv[i], "-v")==0) { verbosidad = TRUE; n++; }
    if (argc == n+1)
        if ((yyin = fopen (argv[n], "r")) == NULL)
            fprintf (stderr, "El fichero ’%s’ no es valido\n", argv[n]) ;
            else yylex ();
    else fprintf (stderr, "Uso: cmc [-v] fichero\n");

    return (0);
}