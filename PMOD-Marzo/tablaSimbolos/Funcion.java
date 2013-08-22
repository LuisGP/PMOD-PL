package tablaSimbolos;

import java_cup.runtime.Symbol;

public class Funcion extends Simbolo{
	private TablaSimbolos tabla;
	
	public Funcion(Symbol sym, String tipo){
		this.simbolo = sym;
		this.lexema = sym.value.toString();
		this.tipo = tipo;
		this.tabla = new TablaSimbolos();
	}
	
	public TablaSimbolos getTabla(){
		return tabla;
	}
}
