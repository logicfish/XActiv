/*
* generated by Xtext
*/
package com.logicfishsoftware.example.xactive.domainmodel;

import org.eclipse.xtext.junit4.IInjectorProvider;

import com.google.inject.Injector;

public class DomainmodelUiInjectorProvider implements IInjectorProvider {
	
	public Injector getInjector() {
		return com.logicfishsoftware.example.xactive.domainmodel.ui.internal.DomainmodelActivator.getInstance().getInjector("com.logicfishsoftware.example.xactive.domainmodel.Domainmodel");
	}
	
}
