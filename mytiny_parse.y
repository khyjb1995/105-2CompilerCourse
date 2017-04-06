%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "mytiny.h"
	#include "mytiny_parse.h"
%}

%token lWRITE lREAD lIF lASSIGN
%token lRETURN lBEGIN lEND
%left  lEQU lNEQ lGT lLT lGE lLE
%left  lADD lMINUS
%left  lTIMES lDIVIDE
%token lLP lRP
%token lINT lREAL lSTRING
%token lELSE
%token lMAIN
%token lSEMI lCOMMA
%token lID lINUM lRNUM lQSTR

%expect 1

%%
prog	:	mthdcls
		{ printf("Program -> MethodDecls\n");
		  printf("Parsed OK!\n"); }
	|
		{ printf("****** Parsing failed!\n"); }	
	;

mthdcls	:	mthdcl mthdcls
		{ printf("MethodDecls -> MethodDecl MethodDecls\n"); }	
	|	mthdcl
		{ printf("MethodDecls -> MethodDecl\n"); }	
	;

type	:	lINT
		{ printf("Type -> INT\n"); }	
	|	lREAL
		{ printf("Type -> REAL\n"); }	
	;

mthdcl	:	type lMAIN lID lLP formals lRP block
		{ printf("MethodDecl -> Type MAIN ID LP Formals RP Block\n"); }	
	|	type lID lLP formals lRP block
		{ printf("MethodDecl -> Type ID LP Formals RP Block\n"); }	
	;

formals	:	formal oformal
		{ printf("Formals -> Formal OtherFormals\n"); }	
	|
		{ printf("Formals -> \n"); }	
	;

formal	:	type lID
		{ printf("Formal -> Type ID\n"); }	
	;

oformal	:	lCOMMA formal oformal
		{ printf("OtherFormals -> COMMA Formal OtherFormals\n"); }	
	|
		{ printf("OtherFormals -> \n"); }	
	;

block	:	lBEGIN stmt ostmt lEND
		{ printf("Block -> BEGIN Stmts END\n"); }
	;

ostmt	:	stmt ostmt
		{ printf("Stmts -> Stmt Stmts\n"); }
	|
		
		{ printf("Stmts ->Stmt\n"); }
	;
	
stmt	:	block
		{ printf("Stmt -> Block\n"); }
	|
		localvd1
		{ printf("Stmt -> LocalVarDec1\n"); }
	|
		assignstmt
		{ printf("Stmt -> AssignStmt\n"); }
	|
		retstmt
		{ printf("Stmt -> ReturnStmt\n"); }
	|
		ifstmt
		{ printf("Stmt -> IfStmt\n"); }
	|
		wrstmt
		{ printf("Stmt -> WriteStmt\n"); }
	|
		rdstmt
		{ printf("Stmt -> ReadStmt\n"); }
	;
	
localvd1	:	type lID lSEMI
		{ printf("LocalVarDec1 -> Type ID SEMI\n"); }
	|
		type assignstmt
		{ printf("LocalVarDec1 -> Type AssignStmt\n"); }
	;
	
assignstmt	:	lID lASSIGN expr lSEMI
		{ printf("AssignStmt -> ID ASSIGN Expr SEMI\n"); }
	;
	
retstmt	:	lRETURN expr lSEMI
		{ printf("ReturnStmt -> RETURN Expr\n"); }
	;
	
ifstmt	:	lIF lLP boolexpr lRP stmt
		{ printf("IfStmt -> IF LP BoolExpr RP Stmt\n"); }
	|
		lIF lLP boolexpr lRP stmt lELSE stmt
		{ printf("IfStmt -> IF LP BoolExpr RP Stmt ELSE Stmt\n"); }
	; 

wrstmt	:	lWRITE lLP expr lCOMMA lQSTR lRP lSEMI
		{ printf("WriteStmt -> WRITE LP Expr COMMA QSTR RP SEMI\n"); }
	;
	
rdstmt	:	lREAD lLP lID lCOMMA lQSTR lRP lSEMI
		{ printf("ReadStmt -> READ LP ID COMMA QSTR RP SEMI\n"); }
	;
	
expr	:	multexpr omultexpr
		{ printf("Expr -> MultiplicativeExpr OtherMultiplicativeExpr\n"); }
	;
	
multexpr	:	priexpr opriexpr
		{ printf("MultiplicativeExpr -> PrimaryExpr OtherPrimaryExpr\n"); }
	;

omultexpr	:	lADD multexpr omultexpr
		{ printf("OtherMultiplicativeExpr -> ADD MultiplicativeExpr OtherMultiplicative\n"); }
	|
		lMINUS multexpr omultexpr
		{ printf("OtherMultiplicativeExpr -> MINUS MultiplicativeExpr OtherMultiplicative\n"); }
	|
		{ printf("OtherMultiplicativeExpr -> \n"); }
	;

priexpr	:	lINUM
		{ printf("PrimaryExpr -> INUM\n"); }
	|
		lRNUM
		{ printf("PrimaryExpr -> RNUM\n"); }
	|
		lID
		{ printf("PrimaryExpr -> ID\n"); }
	|
		lLP expr lRP
		{ printf("PrimaryExpr -> LP ActualParams RP\n"); }
	|
		lID lLP actparams lRP
		{ printf("PrimaryExpr -> ID LP ActualParams RP\n"); }
	;
	
opriexpr	:	lTIMES priexpr opriexpr
		{ printf("OtherPrimaryExpr -> TIMES PriExpr OtherPriExpr\n"); }
	|
		lDIVIDE priexpr opriexpr
		{ printf("OtherPrimaryExpr -> DIVIDE PriExpr OtherPriExpr\n"); }
	|
		{ printf("OtherPrimaryExpr -> \n"); }
	;
	
boolexpr	:	expr lEQU expr
		{ printf("BoolExpr -> Expr EQU Expr\n"); }
	|	
		expr lNEQ expr
		{ printf("BoolExpr -> Expr NEQ Expr\n"); }
	|	
		expr lGT expr
		{ printf("BoolExpr -> Expr GT Expr\n"); }
	|	
		expr lGE expr
		{ printf("BoolExpr -> Expr GE Expr\n"); }
	| 	
		expr lLT expr
		{ printf("BoolExpr -> Expr LTExpr\n"); }
	|	
		expr lLE expr
		{ printf("BoolExpr -> Expr LE Expr\n"); }
	;
	
actparams	:	expr oexpr
		{ printf("ActualParams -> Expr OtherExpr\n"); }
	|
		{ printf("ActualParams -> \n"); }
	;
	
oexpr	:	lCOMMA expr oexpr
		{ printf("OtherFormals -> COMMA Expr OtherExpr\n"); }
	|
		{ printf("OtherExpression -> \n"); }
	;

%%

int yyerror(char *s)
{
	printf("%s\n",s);
	return 1;
}

