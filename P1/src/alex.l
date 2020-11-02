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
comentario \/\/.*
letra [a-z | A-Z]
digito [0-9]
constante {digito}+(\.{digito}+)?
identificador {letra}(_|{letra}|{digito})*

%%

{delimitador} {if (verbosidad) ECHO ; }
{comentario} {if (verbosidad) ECHO ; }

"int" { retornar (INT_); }
"bool" { retornar (BOOL_); }
"return" { retornar (RETRUN_); }
"read" { retornar (READ_); }
"print" { retornar (PRINT_); }
"if" { retornar (IF_); }
"else" { retornar (ELSE_); }
"for" { retornar (FOR_); }
"true" { retornar (TRUE_); }
"false" { retornar (FALSE_); }

"&&" { retornar (OPTAND_); }
"||" { retornar (OPTOR_); }
"==" { retornar (OPTEQ_) ; } 
"!=" { retornar (OPTNEQ_) ; }
">"  { retornar (OPTGRT_) ; }
"<"  { retornar (OPTLSR_) ; }
">=" { retornar (OPTGRTEQ_) ; }
"<=" { retornar (OPTLSREQ_) ; }

"+" { retornar (OPTADD_) ; }
"-" { retornar (OPTSUB_) ; }
"*" { retornar (OPTMULT_) ; }
"/" { retornar (OPTDIV_) ; }

"(" { retornar (PAROPEN_) ; }
")" { retornar (PARCLOSE_) ; }
"[" { retornar (STRBRAKOPEN_) ; }
"]" { retornar (STRBRAKCLOSE_) ; }
"{" { retornar (CRLBRAKOPEN_) ; } 
"}" { retornar (CRLBRAKCLOSE_) ; }
";" { retornar (SEMICOLON_); }

"++" { retornar (OPTINC_) ; }
"--" { retornar (OPTDECR_) ; }
"!" { retornar (OPNOT_);}


{constante} { retornar(CTE_); }
{identificador} { retornar(ID_); }

. { printf("Error [%d]: %s\n", yylineno, yytext); }

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