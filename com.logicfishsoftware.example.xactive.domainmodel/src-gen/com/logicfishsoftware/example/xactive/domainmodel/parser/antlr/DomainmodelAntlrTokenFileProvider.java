/*
* generated by Xtext
*/
package com.logicfishsoftware.example.xactive.domainmodel.parser.antlr;

import java.io.InputStream;
import org.eclipse.xtext.parser.antlr.IAntlrTokenFileProvider;

public class DomainmodelAntlrTokenFileProvider implements IAntlrTokenFileProvider {
	
	public InputStream getAntlrTokenFile() {
		ClassLoader classLoader = getClass().getClassLoader();
    	return classLoader.getResourceAsStream("com/logicfishsoftware/example/xactive/domainmodel/parser/antlr/internal/InternalDomainmodel.tokens");
	}
}
