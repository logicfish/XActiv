
package com.logicfishsoftware.example.xactive.domainmodel.xactive

import org.eclipse.core.runtime.Platform
import com.logicfishsoftware.commons.emf.RuntimeInjectorProvider

class DomainmodelInjectorProviderDefault {
	def static Class<? extends RuntimeInjectorProvider> getDefaultProvider() {
		try {
			if(Platform.isRunning()) { 
				val bundle = Platform.getBundle("com.logicfishsoftware.example.xactive.domainmodel.ui")
				if(bundle!=null) return  bundle.loadClass("com.logicfishsoftware.example.xactive.domainmodel.ui.xactive.DomainmodelUiInjectorProvider") as Class<? extends RuntimeInjectorProvider>
			}
		} catch (Throwable e) {}
		return typeof(com.logicfishsoftware.example.xactive.domainmodel.xactive.DomainmodelInjectorProvider) 
	}
}
