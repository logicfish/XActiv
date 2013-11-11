
package com.logicfishsoftware.example.xactive.domainmodel.xactive

import com.google.inject.Injector
import com.google.inject.Guice

import com.logicfishsoftware.commons.emf.RuntimeInjectorProvider

class DomainmodelInjectorProvider implements RuntimeInjectorProvider {
	override Injector getInjector() {
		return Guice.createInjector(new com.logicfishsoftware.example.xactive.domainmodel.DomainmodelRuntimeModule())
	}
} 
