%{
      #include <stdio.h>
      #include <stdlib.h>
      #include "MathFunctions.cpp"
      extern int yylex();
      extern int yyparse();
      extern FILE* yyin;
      void yyerror(const char *s);
%}

%union { int one; float two; }

%token<one> INTNUMBER
%token<two> FLOATNUMBER

%token NEWLINE
%token EXIT
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token REMAINDER
%token LB
%token RB
%token LSQ
%token RSQ
%token LESS
%token MORE
%token LESSOR
%token MOREOR
%token EQUAL
%token NEQUAL
%token COMMA
%token COMMENT
%token AND
%token OR
%token NOT
%token TFLOOR
%token TCEIL
%token TROUND
%token TABS
%token TPOW
%token TSQRT
%token TFACT
%token TSIN
%token TCOS
%token TTG
%token TCTG
%token TEXP
%token TLN
%token TLOG
%token IF
%token THEN
%token ELSE
%token WHILE
%token FOR

%left OR AND NOT
%left PLUS MINUS
%left MULTIPLY DIVIDE REMAINDER

%type<one> expr1
%type<two> expr2

%start calculation

%%

if1: 
calculation:
	   | calculation line
;

line: NEWLINE
    | expr2 NEWLINE { printf("\tResult: %f\n", $1);}
    | expr1 NEWLINE { printf("\tResult: %i\n", $1); }
    | EXIT NEWLINE { printf("bye!\n"); exit(0); }
;
expr2: FLOATNUMBER              		 { $$ = $1; }
     | expr2 PLUS expr2	         		 { $$ = $1 + $3; }
     | expr2 MINUS expr2	  		 { $$ = $1 - $3; }
     | expr2 MULTIPLY expr2 	  		 { $$ = $1 * $3; }
     | expr2 DIVIDE expr2	  		 { $$ = $1 / $3; }
     | LB expr2 RB  	        		 { $$ = $2; }
     | TFLOOR LSQ expr2 RSQ      		 { $$ = SMIfloor($3); }
     | TCEIL LSQ expr2 RSQ        		 { $$ = SMIceil($3); }
     | TROUND LSQ expr2 RSQ         		 { $$ = SMIround($3); }
     | TABS LSQ expr2 RSQ            		 { $$ = SMIabs($3); }
     | TLN LSQ expr2 RSQ         	         { $$ = SMIln($3); }
     | TEXP LSQ expr2 RSQ       	         { $$ = SMIexp($3); }
     | TSQRT LSQ expr2 RSQ        		 { $$ = SMIsqrt($3); }
     | TSIN LSQ expr2 RSQ       		 { $$ = SMIsin($3); }
     | TCOS LSQ expr2 RSQ       		 { $$ = SMIcos($3); }
     | TTG LSQ expr2 RSQ        		 { $$ = SMItg($3); }
     | TCTG LSQ expr2 RSQ      			 { $$ = SMIctg($3); }
     | TPOW LSQ expr2 COMMA expr2 RSQ  		 { $$ = SMIpow($3, $5); }
     | TLOG LSQ expr2 COMMA expr2 RSQ  		 { $$ = SMIlog($3, $5); }
     | expr1 PLUS expr2	 	   		 { $$ = $1 + $3; }
     | expr1 MINUS expr2	      		 { $$ = $1 - $3; }
     | expr1 MULTIPLY expr2 	   		 { $$ = $1 * $3; }
     | expr1 DIVIDE expr2	   		 { $$ = $1 / $3; }
     | TPOW LSQ expr1 COMMA expr2 RSQ  		 { $$ = SMIpow($3, $5); }
     | TLOG LSQ expr1 COMMA expr2 RSQ  		 { $$ = SMIlog($3, $5); }
     | expr2 PLUS expr1	 	   		 { $$ = $1 + $3; }
     | expr2 MINUS expr1	   		 { $$ = $1 - $3; }
     | expr2 MULTIPLY expr1 	   		 { $$ = $1 * $3; }
     | expr2 DIVIDE expr1	  		 { $$ = $1 / $3; }
     | TPOW LSQ expr2 COMMA expr1 RSQ  		 { $$ = SMIpow($3, $5); }
     | TLOG LSQ expr2 COMMA expr1 RSQ  		 { $$ = SMIlog($3, $5); }
     | expr1 DIVIDE expr1 	   		 { $$ = $1 / (float)$3; }
     | expr1 REMAINDER expr1                     { $$ = $1 % $3; }
     | TPOW LSQ expr1 COMMA expr1 RSQ  		 { $$ = SMIpow($3, $5); }
     | TLOG LSQ expr1 COMMA expr1 RSQ  		 { $$ = SMIlog($3, $5); }
;

expr1: INTNUMBER			     	 { $$ = $1; }
     | expr1 PLUS expr1		   		 { $$ = $1 + $3; }
     | expr1 MINUS expr1	   		 { $$ = $1 - $3; }
     | expr1 MULTIPLY expr1	   		 { $$ = $1 * $3; }
     | LB expr1 RB		   		 { $$ = $2; }
     | TFLOOR LSQ expr1 RSQ          		 { $$ = SMIfloor($3); }
     | TCEIL LSQ expr1 RSQ        		 { $$ = SMIceil($3); }
     | TROUND LSQ expr1 RSQ         		 { $$ = SMIround($3); }
     | TABS LSQ expr1 RSQ            		 { $$ = SMIabs($3); }
     | TFACT LSQ expr1 RSQ          		 { $$ = SMIfact($3); }
     | TLN LSQ expr1 RSQ          		 { $$ = SMIln($3); }
     | TEXP LSQ expr1 RSQ         		 { $$ = SMIexp($3); }
     | TSQRT LSQ expr1 RSQ         		 { $$ = SMIsqrt($3); }
     | TSIN LSQ expr1 RSQ       		 { $$ = SMIsin($3); }
     | TCOS LSQ expr1 RSQ       		 { $$ = SMIcos($3); }
     | TTG LSQ expr1 RSQ       			 { $$ = SMItg($3); }
     | TCTG LSQ expr1 RSQ      			 { $$ = SMIctg($3); }
;

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
