package tablaSimbolos;

import java_cup.runtime.Symbol;

public class Argumento extends Simbolo{
	public Argumento(Symbol sym, String tipo){
		this.simbolo = sym;
		this.tipo = tipo;
		this.lexema = sym.value.toString();
	}
}
