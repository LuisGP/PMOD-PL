# Archivo .flex con la definición del analizador léxico para JFLEX
FLEX_FILE=AnalizadorLexicoPMOD_CUP.flex

# Nombre de la clase que JFLEX genera para el analizador léxico
SCANNER_CLASS=AnalizadorLexicoPMOD

# Archivo .cup con la definición del analizador sintáctico para JAVA CUP
CUP_FILE=pmod.cup

# Nombre de la clase que JAVA CUP genera para el analizador sintáctico
PARSER_CLASS=parser

# Nombre de la clase que JAVA CUP genera para las constantes correspondientes a los tokens
SYMBOLS_CLASS=symbol

# Nombre de la clase principal que utiliza y prueba el analizador sintáctico
MAIN_CLASS=prueba

# Archivo de entrada para comprobar con el analizador sintáctico
INPUT_FILE=prueba.pas

# Indica si ejecutamos el analizador en modo normal (false) o modo depuracion (true)
DEBUG=true


$(MAIN_CLASS).class: $(SCANNER_CLASS).class $(SYMBOLS_CLASS).class
	javac $(MAIN_CLASS).java

$(SCANNER_CLASS).class: $(SCANNER_CLASS).java $(PARSER_CLASS).class $(SYMBOLS_CLASS).class
	javac $(SCANNER_CLASS).java

$(SCANNER_CLASS).java: $(FLEX_FILE)
	jflex.bat $(FLEX_FILE)

$(PARSER_CLASS).class: $(PARSER_CLASS).java
	javac $(PARSER_CLASS).java

$(PARSER_CLASS).java: $(CUP_FILE)
	java java_cup.Main -symbols $(SYMBOLS_CLASS) -nonterms $(CUP_FILE)

$(SYMBOLS_CLASS).class: $(SYMBOLS_CLASS).java
	javac $(SYMBOLS_CLASS).java

$(SYMBOLS_CLASS).java: $(CUP_FILE)
	java java_cup.Main -symbols $(SYMBOLS_CLASS) -nonterms $(CUP_FILE)

clean:
	erase *.class $(PARSER_CLASS).java $(SYMBOLS_CLASS).java $(SCANNER_CLASS).java

run: $(MAIN_CLASS).class
	java $(MAIN_CLASS) $(INPUT_FILE) $(DEBUG)