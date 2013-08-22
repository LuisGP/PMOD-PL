package tablaSimbolos;

import java.util.HashMap;
import java.util.Iterator;

public class TablaSimbolos {
	private HashMap tabla;
	private TablaSimbolos padre;
	private ListaTipos tiposVisibles = new ListaTipos();
	
	public TablaSimbolos(){
		tabla =  new HashMap();
		padre = null;
	}
	
	public TablaSimbolos(TablaSimbolos padre){
		tabla = new HashMap();
		this.padre = padre;
	}
	
	public void addSymbol(Simbolo sym){
		tabla.put(sym.getLexema(),sym);
	}
	
	public boolean esVisible(String lexema){
		if(tabla.containsKey(lexema))
			return true;
		else
			if(padre != null)
				return padre.esVisible(lexema);
			return false;
	}
	
	public void dejarArgs(){
		Iterator it = tabla.values().iterator();
		Simbolo s;
		
		while(it.hasNext()){
			s = (Simbolo)it.next();
			if(! (s instanceof Argumento))
				tabla.remove(s);
		}
	}
	
	public void addTipos(String tipo){
		this.tiposVisibles.add(tipo);
	}
	
	public boolean esTipoVisible(String tipo){
		if(this.tiposVisibles.existe(tipo))
			return true;
		else
			if(padre != null)
				return this.padre.esTipoVisible(tipo);
			return false;
	}
}
