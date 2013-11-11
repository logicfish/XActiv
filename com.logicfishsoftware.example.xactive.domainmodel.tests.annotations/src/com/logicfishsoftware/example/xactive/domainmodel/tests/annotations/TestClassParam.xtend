package com.logicfishsoftware.example.xactive.domainmodel.tests.annotations

import com.google.inject.Inject
import com.logicfishsoftware.commons.xtend.xannotation.XAnnotationsInterpreter
import com.logicfishsoftware.xtend.xactive.lib.XActive
import com.logicfishsoftware.xtend.xactive.lib.XActiveAbstractFieldProcessor
import com.logicfishsoftware.xtend.xactive.lib.XActiveAbstractMethodProcessor
import com.logicfishsoftware.xtend.xactive.lib.XActiveTransformationContext
import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmField
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder

@Target(ElementType.FIELD)
@XActive(TestClassParamProcessor)
annotation TestClassParam {
	Class<?> value
	Class<?>[] moreValues
}

@Target(ElementType.METHOD)
@XActive(TestClassParamMethodProcessor)
annotation TestClassParamMethod {
	Class<?> value
	Class<?>[] moreValues
}

class TestClassParamProcessor extends XActiveAbstractFieldProcessor {

	@Inject extension JvmTypesBuilder

	@Inject extension XAnnotationsInterpreter
	
	override doTransform(EObject source, JvmField jvmTarget, XActiveTransformationContext context) {
		val XAnnotation annotation = source.eContents.filter(typeof(XAnnotation))?.filter[annotationType.qualifiedName==typeof(TestClassParam).name]?.head
		val qName = (annotation.<Class<?>>getXAnnotationValue()?.name)
		
		jvmTarget.documentation = "Type found: " + qName
	}
	
}

class TestClassParamMethodProcessor extends XActiveAbstractMethodProcessor {
	@Inject extension JvmTypesBuilder

	@Inject extension XAnnotationsInterpreter
	
	override doTransform(EObject source, JvmOperation jvmTarget, XActiveTransformationContext context) {
		val XAnnotation annotation = source.eContents.filter(typeof(XAnnotation))?.filter[annotationType.qualifiedName==typeof(TestClassParamMethod).name]?.head
		
		val qName = (annotation.<Class<?>>getXAnnotationValue()?.name)
		
		jvmTarget.documentation = "Type found: " + qName
	}
}

