/* Analizador léxico para práctica de PL*/

import java_cup.runtime.*;

%%

%class AnalizadorLexicoPMOD
%unicode
%line
%column
%cup

%{

StringBuffer string = new StringBuffer();
 
/*private Yytoken symbol(int type) {
    return new Yytoken(type);
}

private Yytoken symbol(int type, Object value) {
    return new Yytoken(type, value);
}*/

    /* To create a new java_cup.runtime.Symbol with information about
       the current token, the token will have no value in this
       case. */
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    /* Also creates a new java_cup.runtime.Symbol with information
       about the current token, but this object has a value. */
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }


private String checkPlus(String str){
	if(str.charAt(0)=='+')
		return str.substring(1);
	return str;
}

private String delDolar(String str){
	if(str.charAt(1)=='+')
		return str.substring(2);
	return str.substring(1);
}

private Double HexStrToDouble(String str){
		double valor = 0.0;
		int length = str.length();
		boolean signo = false;
		int i = 1;
		
		if(str.charAt(1)=='-'){
			signo = true;
			i = 2;
			}
		else
			if(str.charAt(1)=='+'){
			  i = 2;
			}
	
		for(; str.charAt(i) != '.'; i++){
			valor = valor*16 + Character.digit(str.charAt(i),16);
		}
		
		int j = 1;
		for(i++; i < length; i++){
		  valor = valor + Character.digit(str.charAt(i),16)*Math.pow(0.0625,j);
		  j++;
		}

		if(signo)
			return new Double(-valor);

		return new Double(valor);
}

%}



/* Definiciones Léxicas */

DIG_DECIMAL	= [0-9]
DIG_HEXADECIMAL = [0-9A-F]

LETRAS = [a-zA-Z]
CARACTER_ID = "_" | {LETRAS}

FIN_LINEA = \r|\n|\r\n
BLANCO = {FIN_LINEA} | [ \t\f]

/* Numeros */
SIGNO = [+-]
ENTERO_DECIMAL = {SIGNO}?{DIG_DECIMAL}+
ENTERO_HEXADECIMAL = "$"{SIGNO}?{DIG_HEXADECIMAL}+
REAL_DECIMAL = {SIGNO}?{DIG_DECIMAL}+"."{DIG_DECIMAL}+
REAL_HEXADECIMAL = "$"{SIGNO}?{DIG_HEXADECIMAL}+"."{DIG_HEXADECIMAL}+

/* Constantes Literales */
DOS_COMILLAS = "''"
CTE_LITERAL = "'"([^'] | {DOS_COMILLAS})*"'"

/* Identificadores */
/* ID = {CARACTER_ID}[{CARACTER_ID}{DIG_DECIMAL}]* */
ID = {CARACTER_ID}({CARACTER_ID} | {DIG_DECIMAL})*

/* Comentarios */

COM_LLAVES = [^}]*
COM_PARENTESIS = "(""*" [^*]*("*"+[^*)]+[^*]*)* "*"")"
COM_PARENTESIS_INCORRECTO = "(""*" [^*]*("*"+[^*)]+[^*]*)*

COM_CORTO = "**"" "
COM_LARGO = "*"" "
COM_RETORNO = "R"" "
COM_AUTOR = "A"" "
COM_PARAM = "P"

TODO = (.|\n)

%xstate DOCUMENTACION
%xstate NORMAL
%xstate OPERACION
%xstate ERROR

%%

/* Reglas léxicas */

/* PALABRAS RESERVADAS */

{TODO}									{ yybegin(NORMAL); yypushback(1); }
<NORMAL> "program"								{ return symbol(sym.PROGRAM); }
<NORMAL> "begin"									{ return symbol(sym.BEGIN); }
<NORMAL> "end"										{ return symbol(sym.END); }
<NORMAL> "const"									{ return symbol(sym.CONST); }
<NORMAL> "var"										{ return symbol(sym.VAR); }
<NORMAL> "procedure"							{ return symbol(sym.PROCEDURE); }
<NORMAL> "function"							{ return symbol(sym.FUNCTION); }
<NORMAL> "type"									{ return symbol(sym.TYPE); }
<NORMAL> "record"								{ return symbol(sym.RECORD); }
<NORMAL> "while"									{ return symbol(sym.WHILE); }
<NORMAL,OPERACION> "do"										{ yybegin(NORMAL); return symbol(sym.DO); }

<NORMAL> {ENTERO_DECIMAL}				{ yybegin(OPERACION); return symbol(sym.NUM_CONST, Long.valueOf(checkPlus(yytext()))); }
<NORMAL> {ENTERO_HEXADECIMAL}		{ yybegin(OPERACION); return symbol(sym.NUM_CONST, Long.valueOf(delDolar(yytext()), 16)); }
<NORMAL> {REAL_DECIMAL}					{ yybegin(OPERACION); return symbol(sym.NUM_CONST, Double.valueOf(yytext())); }
<NORMAL> {REAL_HEXADECIMAL}			{ yybegin(OPERACION); return symbol(sym.NUM_CONST, HexStrToDouble(yytext())); }

<NORMAL> {CTE_LITERAL}					{ return symbol(sym.CTE_LITERAL, (yytext().substring(1,yytext().length()-1)).replaceAll("''","'")); }

/* SIMBOLOS */

<NORMAL,OPERACION> ":="										{ yybegin(NORMAL); return symbol(sym.ASIG); }
<NORMAL,OPERACION> "<"											{ yybegin(NORMAL); return symbol(sym.MENOR); }
<NORMAL,OPERACION> ">"											{ yybegin(NORMAL); return symbol(sym.MAYOR); }
<NORMAL,OPERACION> "<="										{ yybegin(NORMAL); return symbol(sym.MENORIGUAL); }
<NORMAL,OPERACION> ">="										{ yybegin(NORMAL); return symbol(sym.MAYORIGUAL); }
<NORMAL,OPERACION> "="											{ yybegin(NORMAL); return symbol(sym.IGUAL); }
<NORMAL,OPERACION> "<>"										{ yybegin(NORMAL); return symbol(sym.DISTINTO); }
<NORMAL,OPERACION> "+"											{ yybegin(NORMAL); return symbol(sym.SUMA); }
<NORMAL,OPERACION> "-"											{ yybegin(NORMAL); return symbol(sym.RESTA); }
<NORMAL,OPERACION> "*"											{ yybegin(NORMAL); return symbol(sym.MULT); }
<NORMAL,OPERACION> "div"										{ yybegin(NORMAL); return symbol(sym.DIV); }
<NORMAL,OPERACION> "mod"										{ yybegin(NORMAL); return symbol(sym.MOD); }
<NORMAL,OPERACION> "or"										{ yybegin(NORMAL); return symbol(sym.OR); }
<NORMAL,OPERACION> "and"										{ yybegin(NORMAL); return symbol(sym.AND); }
<NORMAL,OPERACION> "not"										{ yybegin(NORMAL); return symbol(sym.NOT); }
<NORMAL,OPERACION> ";"											{ yybegin(NORMAL); return symbol(sym.PCOMA); }
<NORMAL,OPERACION> "."											{ yybegin(NORMAL); return symbol(sym.PUNTO); }
<NORMAL,OPERACION> ","											{ yybegin(NORMAL); return symbol(sym.COMA); }
<NORMAL,OPERACION> "("											{ yybegin(NORMAL); return symbol(sym.PAR_ABR); }
<NORMAL,OPERACION> ")"											{ yybegin(OPERACION); return symbol(sym.PAR_CER); }
<NORMAL,OPERACION> ":"											{ yybegin(NORMAL); return symbol(sym.DOS_PUNTOS); }

/* Resto */

<NORMAL,OPERACION> {COM_PARENTESIS}				{ yybegin(NORMAL); }
//<NORMAL,OPERACION> {COM_PARENTESIS_INCORRECTO}				{ yybegin(NORMAL); System.out.println("Error lexico en linea = "+yyline+", columna = "+yycolumn); return symbol(sym.LEXERROR, yytext().substring(0,yytext().indexOf('\n'))); }
<NORMAL> {ID}										{ yybegin(OPERACION); return symbol(sym.ID, yytext()); }
<NORMAL,OPERACION> {BLANCO}								{ yybegin(NORMAL); }




<NORMAL,OPERACION> "{"											{ yybegin(DOCUMENTACION); yypushback(1); }

<DOCUMENTACION> "{"{COM_CORTO}[^}]*"}"   { yybegin(NORMAL); return symbol(sym.COM_CORTO, yytext().substring(4,yytext().length()-1)); }
<DOCUMENTACION> "{"{COM_LARGO}[^}]*"}"		{ yybegin(NORMAL); return symbol(sym.COM_LARGO, yytext().substring(3,yytext().length()-1)); }
<DOCUMENTACION> "{"{COM_AUTOR}[^}]*"}"		{ yybegin(NORMAL); return symbol(sym.COM_AUTOR, yytext().substring(3,yytext().length()-1)); }
<DOCUMENTACION> "{"{COM_PARAM}"}"		{ yybegin(NORMAL); return symbol(sym.COM_PARAM); }
<DOCUMENTACION> "{"{COM_RETORNO}[^}]*"}"	{ yybegin(NORMAL); return symbol(sym.COM_RETORNO, yytext().substring(3,yytext().length()-1)); }
<DOCUMENTACION> "{"{COM_LLAVES}"}"	{ yybegin(NORMAL); }

<DOCUMENTACION> "{"[^}]*   { yybegin(NORMAL); System.err.println("Error lexico en linea = "+(yyline+1)+", columna = "+(yycolumn+1)); return symbol(sym.LEXERROR, yytext().substring(0,yytext().indexOf('\n'))); }

<NORMAL,OPERACION> .	{ yybegin(NORMAL); System.err.println("Error lexico en linea = "+(yyline+1)+", columna = "+(yycolumn+1)); return symbol(sym.LEXERROR, yytext().substring(0,yytext().indexOf('\n'))); }