package tablaSimbolos;

import java_cup.runtime.Symbol;

public class Variable extends Simbolo{
	public Variable(Symbol sym, String tipo){
		this.simbolo = sym;
		this.tipo = tipo;
		this.lexema = sym.value.toString();
	}
}
