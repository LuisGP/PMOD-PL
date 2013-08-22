/* Analizador léxico para práctica de PL*/

import java_cup.runtime.*;

%%

%class AnalizadorLexicoPMOD
%unicode
%line
%column
%cup

%eofval{
	return symbol(symbol.EOF); 
%eofval}

%{

private MySymbol symbol(int type) {
	return new MySymbol(type, yyline, yycolumn);
}
    
private MySymbol symbol(int type, Object value) {
	return new MySymbol(type, yyline, yycolumn, value);
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
<NORMAL> "program"								{ return symbol(symbol.PROGRAM); }
<NORMAL> "begin"									{ return symbol(symbol.BEGIN); }
<NORMAL> "end"										{ return symbol(symbol.END); }
<NORMAL> "const"									{ return symbol(symbol.CONST); }
<NORMAL> "var"										{ return symbol(symbol.VAR); }
<NORMAL> "procedure"							{ return symbol(symbol.PROCEDURE); }
<NORMAL> "function"							{ return symbol(symbol.FUNCTION); }
<NORMAL> "type"									{ return symbol(symbol.TYPE); }
<NORMAL> "record"								{ return symbol(symbol.RECORD); }
<NORMAL> "while"									{ return symbol(symbol.WHILE); }
<NORMAL,OPERACION> "do"										{ yybegin(NORMAL); return symbol(symbol.DO); }

<NORMAL> {ENTERO_DECIMAL}				{ yybegin(OPERACION); return symbol(symbol.NUM_CONST, Long.valueOf(checkPlus(yytext()))); }
<NORMAL> {ENTERO_HEXADECIMAL}		{ yybegin(OPERACION); return symbol(symbol.NUM_CONST, Long.valueOf(delDolar(yytext()), 16)); }
<NORMAL> {REAL_DECIMAL}					{ yybegin(OPERACION); return symbol(symbol.NUM_CONST, Double.valueOf(yytext())); }
<NORMAL> {REAL_HEXADECIMAL}			{ yybegin(OPERACION); return symbol(symbol.NUM_CONST, HexStrToDouble(yytext())); }

<NORMAL> {CTE_LITERAL}					{ return symbol(symbol.CTE_LITERAL, (yytext().substring(1,yytext().length()-1)).replaceAll("''","'")); }

/* SIMBOLOS */

<NORMAL,OPERACION> ":="										{ yybegin(NORMAL); return symbol(symbol.ASIG); }
<NORMAL,OPERACION> "<"											{ yybegin(NORMAL); return symbol(symbol.MENOR); }
<NORMAL,OPERACION> ">"											{ yybegin(NORMAL); return symbol(symbol.MAYOR); }
<NORMAL,OPERACION> "<="										{ yybegin(NORMAL); return symbol(symbol.MENORIGUAL); }
<NORMAL,OPERACION> ">="										{ yybegin(NORMAL); return symbol(symbol.MAYORIGUAL); }
<NORMAL,OPERACION> "="											{ yybegin(NORMAL); return symbol(symbol.IGUAL); }
<NORMAL,OPERACION> "<>"										{ yybegin(NORMAL); return symbol(symbol.DISTINTO); }
<NORMAL,OPERACION> "+"											{ yybegin(NORMAL); return symbol(symbol.SUMA); }
<NORMAL,OPERACION> "-"											{ yybegin(NORMAL); return symbol(symbol.RESTA); }
<NORMAL,OPERACION> "*"											{ yybegin(NORMAL); return symbol(symbol.MULT); }
<NORMAL,OPERACION> "div"										{ yybegin(NORMAL); return symbol(symbol.DIV); }
<NORMAL,OPERACION> "mod"										{ yybegin(NORMAL); return symbol(symbol.MOD); }
<NORMAL,OPERACION> "or"										{ yybegin(NORMAL); return symbol(symbol.OR); }
<NORMAL,OPERACION> "and"										{ yybegin(NORMAL); return symbol(symbol.AND); }
<NORMAL,OPERACION> "not"										{ yybegin(NORMAL); return symbol(symbol.NOT); }
<NORMAL,OPERACION> ";"											{ yybegin(NORMAL); return symbol(symbol.PCOMA); }
<NORMAL,OPERACION> "."											{ yybegin(NORMAL); return symbol(symbol.PUNTO); }
<NORMAL,OPERACION> ","											{ yybegin(NORMAL); return symbol(symbol.COMA); }
<NORMAL,OPERACION> "("											{ yybegin(NORMAL); return symbol(symbol.PAR_ABR); }
<NORMAL,OPERACION> ")"											{ yybegin(OPERACION); return symbol(symbol.PAR_CER); }
<NORMAL,OPERACION> ":"											{ yybegin(NORMAL); return symbol(symbol.DOS_PUNTOS); }

/* Resto */

<NORMAL,OPERACION> {COM_PARENTESIS}				{ yybegin(NORMAL); }
//<NORMAL,OPERACION> {COM_PARENTESIS_INCORRECTO}				{ yybegin(NORMAL); System.out.println("Error lexico en linea = "+yyline+", columna = "+yycolumn); return symbol(symbol.LEXERROR, yytext()); }
<NORMAL> {ID}										{ yybegin(OPERACION); return symbol(symbol.ID, yytext()); }
<NORMAL,OPERACION> {BLANCO}								{ yybegin(NORMAL); }




<NORMAL,OPERACION> "{"											{ yybegin(DOCUMENTACION); yypushback(1); }

<DOCUMENTACION> "{"{COM_CORTO}[^}]*"}"   { yybegin(NORMAL); return symbol(symbol.COM_CORTO, yytext().substring(4,yytext().length()-1)); }
<DOCUMENTACION> "{"{COM_LARGO}[^}]*"}"		{ yybegin(NORMAL); return symbol(symbol.COM_LARGO, yytext().substring(3,yytext().length()-1)); }
<DOCUMENTACION> "{"{COM_AUTOR}[^}]*"}"		{ yybegin(NORMAL); return symbol(symbol.COM_AUTOR, yytext().substring(3,yytext().length()-1)); }
<DOCUMENTACION> "{"{COM_PARAM}"}"		{ yybegin(NORMAL); return symbol(symbol.COM_PARAM); }
<DOCUMENTACION> "{"{COM_RETORNO}[^}]*"}"	{ yybegin(NORMAL); return symbol(symbol.COM_RETORNO, yytext().substring(3,yytext().length()-1)); }
<DOCUMENTACION> "{"{COM_LLAVES}"}"	{ yybegin(NORMAL); }

//<DOCUMENTACION> "{"[^}]*   { yybegin(NORMAL); System.out.println("Error lexico en linea = "+yyline+", columna = "+yycolumn); return symbol(symbol.LEXERROR, yytext()); }

//<NORMAL,OPERACION> .	{ yybegin(NORMAL); System.out.println("Error lexico en linea = "+yyline+", columna = "+yycolumn); return symbol(symbol.LEXERROR, yytext()); }