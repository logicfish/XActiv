package com.logicfishsoftware.example.xactive.domainmodel.tests.annotations

import com.logicfishsoftware.xtend.xactive.lib.XActive
import com.logicfishsoftware.xtend.xactive.lib.XActiveAbstractMethodProcessor
import com.logicfishsoftware.xtend.xactive.lib.XActiveTransformationContext
import java.lang.annotation.ElementType
import java.lang.annotation.Retention
import java.lang.annotation.RetentionPolicy
import java.lang.annotation.Target
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmOperation

@XActive(typeof(SynchronizeTestXProcessor))
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
annotation SynchronizeTest {
}

class SynchronizeTestXProcessor extends XActiveAbstractMethodProcessor {
	
	override doTransform(EObject source, JvmOperation jvmTarget, XActiveTransformationContext context) {
		jvmTarget.synchronized = true
	}
	
}

