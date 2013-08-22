package tablaSimbolos;

import java_cup.runtime.Symbol;

public class Literal extends Simbolo{
	public Literal(Symbol sym, String tipo){
		this.simbolo = sym;
		this.tipo = tipo;
		this.lexema = sym.value.toString();
	}
	
	public String getTipo(){
		return this.tipo;
	}
	
	public Object getValor(){
		return this.lexema;
	}

}
