import java.io.FileInputStream;

public class prueba {
	public static void main(String[] args) {
		AnalizadorLexicoPMOD lex = null;
		parser parser_obj = null;
//		java_cup.runtime.Symbol s = null;

		if (args.length != 2) {
			System.out.println("Usage: java prueba file debug");
			return;
		}
		try {
			lex = new AnalizadorLexicoPMOD(new FileInputStream(args[0]));
			parser_obj = new parser(lex);
			if (Boolean.parseBoolean(args[1]))
				/*s =*/ parser_obj.debug_parse();
			else
				/*s =*/ parser_obj.parse();
		} catch (Exception e) {
			System.out.println("Error");
		}
	}
}