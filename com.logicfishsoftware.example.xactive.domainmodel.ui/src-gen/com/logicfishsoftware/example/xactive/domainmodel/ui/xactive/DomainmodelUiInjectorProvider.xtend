
package com.logicfishsoftware.example.xactive.domainmodel.ui.xactive

import com.google.inject.Injector

import com.logicfishsoftware.commons.emf.RuntimeInjectorProvider

class DomainmodelUiInjectorProvider implements RuntimeInjectorProvider {
	override Injector getInjector() {
		return com.logicfishsoftware.example.xactive.domainmodel.ui.internal.DomainmodelActivator.getInstance().getInjector("com.logicfishsoftware.example.xactive.domainmodel.Domainmodel")
	}
} 
