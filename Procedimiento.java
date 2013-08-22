package tablaSimbolos;

import java_cup.runtime.Symbol;

public class Procedimiento extends Simbolo{
	private TablaSimbolos tabla;
	
	public Procedimiento(Symbol sym){
		this.simbolo = sym;
		this.lexema = sym.value.toString();
		this.tipo = "PROCEDIMIENTO";
		this.tabla = new TablaSimbolos();
	}
	
	public TablaSimbolos getTabla(){
		return tabla;
	}
}
