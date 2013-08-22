package tablaSimbolos;

import java.util.Vector;

public class ListaTipos {
	public static String entero = "INTEGER";
	public static String real = "REAL";
	public static String string = "STRING";
	
	private Vector tipos = new Vector();
	
	public ListaTipos(){
		tipos.add(entero);
		tipos.add(real);
		tipos.add(string);
	}
	
	public boolean existe(String str){
		return tipos.contains(str);
	}
	
	public void add(String str){
		if(!existe(str))
			tipos.add(str);
	}
	
	public void remove(String str){
		tipos.remove(str);
	}
}
