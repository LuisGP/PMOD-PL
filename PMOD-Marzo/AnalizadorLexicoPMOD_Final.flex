/* Analizador léxico para práctica de PL*/

import java_cup.runtime.*;

%%

%class AnalizadorLexicoPMOD
%unicode
%line
%column
%cup

%eofval{
	return symbol(Yytoken.YYEOF); 
%eofval}

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
<NORMAL> "program"								{ return symbol(Yytoken.PROGRAM); }
<NORMAL> "begin"									{ return symbol(Yytoken.BEGIN); }
<NORMAL> "end"										{ return symbol(Yytoken.END); }
<NORMAL> "const"									{ return symbol(Yytoken.CONST); }
<NORMAL> "var"										{ return symbol(Yytoken.VAR); }
<NORMAL> "procedure"							{ return symbol(Yytoken.PROCEDURE); }
<NORMAL> "function"							{ return symbol(Yytoken.FUNCTION); }
<NORMAL> "type"									{ return symbol(Yytoken.TYPE); }
<NORMAL> "array"									{ return symbol(Yytoken.ARRAY); }
<NORMAL> "of"										{ return symbol(Yytoken.OF); }
<NORMAL> "record"								{ return symbol(Yytoken.RECORD); }
<NORMAL> "if"										{ return symbol(Yytoken.IF); }
<NORMAL> "then"									{ return symbol(Yytoken.THEN); }
<NORMAL> "else"									{ return symbol(Yytoken.ELSE); }
<NORMAL> "while"									{ return symbol(Yytoken.WHILE); }
<NORMAL,OPERACION> "do"										{ yybegin(NORMAL); return symbol(Yytoken.DO); }
<NORMAL> "for"										{ return symbol(Yytoken.FOR); }
<NORMAL> "to"										{ return symbol(Yytoken.TO); }
<NORMAL> "case"									{ return symbol(Yytoken.CASE); }

<NORMAL> {ENTERO_DECIMAL}				{ yybegin(OPERACION); return symbol(Yytoken.NUM_CONST, Long.valueOf(checkPlus(yytext()))); }
<NORMAL> {ENTERO_HEXADECIMAL}		{ yybegin(OPERACION); return symbol(Yytoken.NUM_CONST, Long.valueOf(delDolar(yytext()), 16)); }
<NORMAL> {REAL_DECIMAL}					{ yybegin(OPERACION); return symbol(Yytoken.NUM_CONST, Double.valueOf(yytext())); }
<NORMAL> {REAL_HEXADECIMAL}			{ yybegin(OPERACION); return symbol(Yytoken.NUM_CONST, HexStrToDouble(yytext())); }

<NORMAL> {CTE_LITERAL}					{ return symbol(Yytoken.CTE_LITERAL, (yytext().substring(1,yytext().length()-1)).replaceAll("''","'")); }

/* SIMBOLOS */

<NORMAL,OPERACION> ":="										{ yybegin(NORMAL); return symbol(Yytoken.ASIG); }
<NORMAL,OPERACION> "<"											{ yybegin(NORMAL); return symbol(Yytoken.MENOR); }
<NORMAL,OPERACION> ">"											{ yybegin(NORMAL); return symbol(Yytoken.MAYOR); }
<NORMAL,OPERACION> "<="										{ yybegin(NORMAL); return symbol(Yytoken.MENORIGUAL); }
<NORMAL,OPERACION> ">="										{ yybegin(NORMAL); return symbol(Yytoken.MAYORIGUAL); }
<NORMAL,OPERACION> "="											{ yybegin(NORMAL); return symbol(Yytoken.IGUAL); }
<NORMAL,OPERACION> "<>"										{ yybegin(NORMAL); return symbol(Yytoken.DISTINTO); }
<NORMAL,OPERACION> "+"											{ yybegin(NORMAL); return symbol(Yytoken.SUMA); }
<NORMAL,OPERACION> "-"											{ yybegin(NORMAL); return symbol(Yytoken.RESTA); }
<NORMAL,OPERACION> "*"											{ yybegin(NORMAL); return symbol(Yytoken.MULT); }
<NORMAL,OPERACION> "div"										{ yybegin(NORMAL); return symbol(Yytoken.DIV); }
<NORMAL,OPERACION> "mod"										{ yybegin(NORMAL); return symbol(Yytoken.MOD); }
<NORMAL,OPERACION> "or"										{ yybegin(NORMAL); return symbol(Yytoken.OR); }
<NORMAL,OPERACION> "and"										{ yybegin(NORMAL); return symbol(Yytoken.AND); }
<NORMAL,OPERACION> "not"										{ yybegin(NORMAL); return symbol(Yytoken.NOT); }
<NORMAL,OPERACION> ";"											{ yybegin(NORMAL); return symbol(Yytoken.PCOMA); }
<NORMAL,OPERACION> "."											{ yybegin(NORMAL); return symbol(Yytoken.PUNTO); }
<NORMAL,OPERACION> ","											{ yybegin(NORMAL); return symbol(Yytoken.COMA); }
<NORMAL,OPERACION> "("											{ yybegin(NORMAL); return symbol(Yytoken.PAR_ABR); }
<NORMAL,OPERACION> ")"											{ yybegin(OPERACION); return symbol(Yytoken.PAR_CER); }
<NORMAL,OPERACION> ":"											{ yybegin(NORMAL); return symbol(Yytoken.DOS_PUNTOS); }
<NORMAL,OPERACION> ".."										{ yybegin(NORMAL); return symbol(Yytoken.PUNTO_PUNTO); }

/* Resto */

<NORMAL,OPERACION> {COM_PARENTESIS}				{ yybegin(NORMAL); }
<NORMAL,OPERACION> {COM_PARENTESIS_INCORRECTO}				{ yybegin(NORMAL); System.out.println("Error lexico en linea = "+yyline+", columna = "+yycolumn); return symbol(Yytoken.LEXERROR, yytext()); }
<NORMAL> {ID}										{ yybegin(OPERACION); return symbol(Yytoken.ID, yytext()); }
<NORMAL,OPERACION> {BLANCO}								{ yybegin(NORMAL); }




<NORMAL,OPERACION> "{"											{ yybegin(DOCUMENTACION); yypushback(1); }

<DOCUMENTACION> "{"{COM_CORTO}[^}]*"}"   { yybegin(NORMAL); return symbol(Yytoken.COM_CORTO, yytext().substring(4,yytext().length()-1)); }
<DOCUMENTACION> "{"{COM_LARGO}[^}]*"}"		{ yybegin(NORMAL); return symbol(Yytoken.COM_LARGO, yytext().substring(3,yytext().length()-1)); }
<DOCUMENTACION> "{"{COM_AUTOR}[^}]*"}"		{ yybegin(NORMAL); return symbol(Yytoken.COM_AUTOR, yytext().substring(3,yytext().length()-1)); }
<DOCUMENTACION> "{"{COM_PARAM}"}"		{ yybegin(NORMAL); return symbol(Yytoken.COM_PARAM); }
<DOCUMENTACION> "{"{COM_RETORNO}[^}]*"}"	{ yybegin(NORMAL); return symbol(Yytoken.COM_RETORNO, yytext().substring(3,yytext().length()-1)); }
<DOCUMENTACION> "{"{COM_LLAVES}"}"	{ yybegin(NORMAL); }

<DOCUMENTACION> "{"[^}]*   { yybegin(NORMAL); System.out.println("Error lexico en linea = "+yyline+", columna = "+yycolumn); return symbol(Yytoken.LEXERROR, yytext()); }

<NORMAL,OPERACION> .	{ yybegin(NORMAL); System.out.println("Error lexico en linea = "+yyline+", columna = "+yycolumn); return symbol(Yytoken.LEXERROR, yytext()); }