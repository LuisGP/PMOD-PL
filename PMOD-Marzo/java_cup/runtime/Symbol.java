package java_cup.runtime;


/**
 * Defines the Symbol class, which is used to represent all terminals
 * and nonterminals while parsing.  The lexer should pass CUP Symbols 
 * and CUP returns a Symbol.
 *
 * @version last updated: 7/3/96
 * @author  Frank Flannery
 */

/* ****************************************************************
  Class Symbol
  what the parser expects to receive from the lexer. 
  the token is identified as follows:
  sym:    the symbol type
  parse_state: the parse state.
  value:  is the lexical value of type Object
  left :  is the left position in the original input file
  right:  is the right position in the original input file
******************************************************************/

public class Symbol {

/*******************************
  Constructor for l,r values
 *******************************/

  public Symbol(int id, int l, int r, Object o) {
    this(id);
    left = l;
    right = r;
    value = o;
  }

/*******************************
  Constructor for no l,r values
********************************/

  public Symbol(int id, Object o) {
    this(id, -1, -1, o);
  }

/*****************************
  Constructor for no value
  ***************************/

  public Symbol(int id, int l, int r) {
    this(id, l, r, null);
  }

/***********************************
  Constructor for no value or l,r
***********************************/

  public Symbol(int sym_num) {
    this(sym_num, -1);
    left = -1;
    right = -1;
    value = null;
  }

/***********************************
  Constructor to give a start state
***********************************/
  Symbol(int sym_num, int state)
    {
      sym = sym_num;
      parse_state = state;
    }

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

  /** The symbol number of the terminal or non terminal being represented */
  public int sym;

  /*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/

  /** The parse state to be recorded on the parse stack with this symbol.
   *  This field is for the convenience of the parser and shouldn't be 
   *  modified except by the parser. 
   */
  public int parse_state;
  /** This allows us to catch some errors caused by scanners recycling
   *  symbols.  For the use of the parser only. [CSA, 23-Jul-1999] */
  boolean used_by_parser = false;

/*******************************
  The data passed to parser
 *******************************/

  public int left, right;
  public Object value;

  /*****************************
    Printing this token out. (Override for pretty-print).
    ****************************/
  public String toString(){
		switch(sym)
		{
			case tokens.PROGRAM: return new String("<PROGRAM>");
			case tokens.BEGIN: return new String("<BEGIN>"); 
			case tokens.END: return new String("<END>"); 
			case tokens.CONST: return new String("<CONST>"); 
			case tokens.VAR: return new String("<VAR>"); 
			case tokens.PROCEDURE: return new String("<PROCEDURE>"); 
			case tokens.FUNCTION: return new String("<FUNCTION>"); 
			case tokens.TYPE: return new String("<TYPE>"); 
			case tokens.RECORD: return new String("<RECORD>"); 
			case tokens.WHILE: return new String("<WHILE>"); 
			case tokens.DO: return new String("<DO>"); 
			case tokens.ASIG: return new String("<ASIG>"); 
			case tokens.MENOR: return new String("<MENOR>"); 
			case tokens.MAYOR: return new String("<MAYOR>"); 
			case tokens.MENORIGUAL: return new String("<MENORIGUAL>"); 
			case tokens.MAYORIGUAL: return new String("<MAYORIGUAL>"); 
			case tokens.IGUAL: return new String("<IGUAL>"); 
			case tokens.DISTINTO: return new String("<DISTINTO>"); 
			case tokens.SUMA: return new String("<SUMA>"); 
			case tokens.RESTA: return new String("<RESTA>"); 
			case tokens.MULT: return new String("<MULT>"); 
			case tokens.DIV: return new String("<DIV>"); 
			case tokens.MOD: return new String("<MOD>"); 
			case tokens.OR: return new String("<OR>"); 
			case tokens.AND: return new String("<AND>"); 
			case tokens.NOT: return new String("<NOT>"); 
			case tokens.PCOMA: return new String("<PCOMA>"); 
			case tokens.PUNTO: return new String("<PUNTO>"); 
			case tokens.COMA: return new String("<COMA>"); 
			case tokens.PAR_ABR: return new String("<PAR_ABR>"); 
			case tokens.PAR_CER: return new String("<PAR_CER>"); 
			case tokens.DOS_PUNTOS: return new String("<DOS_PUNTOS>"); 
			case tokens.ID: return new String("<ID>"); 
			case tokens.NUM_CONST: return new String("<NUM_CONST>"); 
			case tokens.COM_CORTO: return new String("<COM_CORTO>"); 
			case tokens.COM_LARGO: return new String("<COM_LARGO>"); 
			case tokens.COM_AUTOR: return new String("<COM_AUTOR>"); 
			case tokens.COM_PARAM: return new String("<COM_PARAM>"); 
			case tokens.COM_RETORNO: return new String("<COM_RETORNO>"); 
			case tokens.LEXERROR: return new String("<ERROR>");
//			case tokens.YYEOF: return new String("<EOF>");
			case tokens.CTE_LITERAL: return new String("<CTE_LITERAL>");
		}
		return new String("<??>");
	}
}






