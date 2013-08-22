package tablaSimbolos;

import java_cup.runtime.Symbol;

public abstract class Simbolo{
	protected Symbol simbolo;
	protected String lexema;
	protected String tipo;
	
	public String getTipo(){
		return tipo;
	}

	public String getLexema(){
		return lexema;
	}

	public Symbol getSimbolo(){
		return simbolo;
	}
}
