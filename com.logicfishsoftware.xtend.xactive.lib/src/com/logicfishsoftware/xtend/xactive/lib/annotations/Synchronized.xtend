package com.logicfishsoftware.xtend.xactive.lib.annotations

import com.logicfishsoftware.xtend.xactive.lib.XActive
import com.logicfishsoftware.xtend.xactive.lib.XActiveAbstractMethodProcessor
import com.logicfishsoftware.xtend.xactive.lib.XActiveTransformationContext
import java.lang.annotation.ElementType
import java.lang.annotation.Retention
import java.lang.annotation.RetentionPolicy
import java.lang.annotation.Target
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.macro.AbstractMethodProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration
import org.eclipse.xtext.common.types.JvmOperation

@Active(typeof(SynchronizeProcessor))
@XActive(typeof(SynchronizeXProcessor))
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
annotation Synchronize {
}

class SynchronizeXProcessor extends XActiveAbstractMethodProcessor {
	
	override doTransform(EObject source, JvmOperation jvmTarget, XActiveTransformationContext context) {
		jvmTarget.synchronized = true
	}
	
}

class SynchronizeProcessor extends AbstractMethodProcessor {
	
	override doTransform(MutableMethodDeclaration annotatedMethod, extension TransformationContext context) {
		annotatedMethod.synchronized = true
	}
	
}