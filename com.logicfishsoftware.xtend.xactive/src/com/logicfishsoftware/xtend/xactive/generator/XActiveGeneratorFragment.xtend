package com.logicfishsoftware.xtend.xactive.generator

import com.google.inject.name.Names
import com.logicfishsoftware.commons.emf.RuntimeInjectorProvider
import com.logicfishsoftware.xtend.xactive.XActiv
import com.logicfishsoftware.xtend.xactive.XActiveCompiler
import com.logicfishsoftware.xtend.xactive.XActiveCompilerImpl
import com.logicfishsoftware.xtend.xactive.lib.XActiveLib
import org.eclipse.xtext.Grammar
import org.eclipse.xtext.GrammarUtil
import org.eclipse.xtext.generator.AbstractGeneratorFragment
import org.eclipse.xtext.generator.BindFactory
import org.eclipse.xtext.generator.Naming

class XActiveGeneratorFragment extends AbstractGeneratorFragment {
	
	override getGuiceBindingsRt(Grammar grammar) {
		val BindFactory config = new BindFactory()
			.addTypeToType(
				typeof(XActiveCompiler).name,
				typeof(XActiveCompilerImpl).name
			)
			.addConfiguredBinding(typeof(RuntimeInjectorProvider).name,
				'''
					binder.bind(
						«typeof(RuntimeInjectorProvider).name».class
					).annotatedWith(
						«typeof(Names).name».named("«XActiv.ID»")
					).to(
						«grammar.getQualifiedInjectorProviderName(naming)»Default.getDefaultProvider()
					) '''
			)
			
		return config.bindings
	}
	
	override getRequiredBundlesRt(Grammar grammar) {
		return #[ XActiveLib.ID ]
	}
	
	override getImportedPackagesRt(Grammar grammar) {
		return #["org.eclipse.core.runtime","org.osgi.framework","com.logicfishsoftware.commons.emf"]
	}
	
	override getImportedPackagesUi(Grammar grammar) {
		return #["com.logicfishsoftware.commons.emf"]
	}

	override getExportedPackagesUi(Grammar grammar) {
		return #[ naming.basePackageUi(grammar) + ".xactive" ]
	}
	
	def static String getQualifiedInjectorProviderName(Grammar grammar, Naming naming) {
		return naming.basePackageRuntime(grammar) + ".xactive." + GrammarUtil.getName(grammar) + "InjectorProvider";
	}

	def static String getQualifiedUiInjectorProviderName(Grammar grammar, Naming naming) {
		return naming.basePackageUi(grammar) + ".xactive." + GrammarUtil.getName(grammar) + "UiInjectorProvider";
	}

}