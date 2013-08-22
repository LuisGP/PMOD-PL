package tablaSimbolos;

import java.util.ArrayList;

public class ListaIDs {
	ArrayList lista;

	public ListaIDs() {
		this.lista = new ArrayList();
	}

	public void add(Simbolo id) {
		this.lista.add(id);
	}

	public void add(ListaIDs l) {
		this.lista.addAll(l.lista);
	}
}
