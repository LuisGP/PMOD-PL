package tablaSimbolos;

import java_cup.runtime.Symbol;

public class Constante extends Simbolo{
	private Object valor;
	
	public Constante(Symbol sym, Object valor, String tipo){
		this.simbolo = sym;
		this.lexema = sym.value.toString();
		this.valor = valor;
		this.tipo = tipo;
	}

	public Object getValor() {
		return valor;
	}
}
