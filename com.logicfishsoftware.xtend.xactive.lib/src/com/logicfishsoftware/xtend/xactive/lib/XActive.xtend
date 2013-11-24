package com.logicfishsoftware.xtend.xactive.lib

import java.lang.annotation.ElementType
import java.lang.annotation.Retention
import java.lang.annotation.RetentionPolicy
import java.lang.annotation.Target
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmField
import org.eclipse.xtext.common.types.JvmIdentifiableElement
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation

@Target(ElementType.ANNOTATION_TYPE)
@Retention(RetentionPolicy.RUNTIME)
annotation XActive {
	Class<?> value
	boolean opaque=true
}

//interface XAnnotationParser {
//	def <T> T getAnnotationValue(String simpleName)
//	def <T> T getAnnotationValue()
//}
//
//interface XAnnotationSource {
//	def XAnnotation getAnnotation()
//}

interface XProblemSupport {
	def void addError(EObject source,String error)
	def void addWarning(EObject source,String error)
}

interface XActiveRegisterGlobalsContext {}

interface XActiveTransformationContext extends XProblemSupport {}

interface XActiveCodeGenerationContext {}

interface XActiveTransformationParticipant<T extends JvmIdentifiableElement> {
	def void doTransform(EObject source,T jvmTarget,XActiveTransformationContext context)	
}

interface XActiveRegisterGlobalsParticipant {
//	def void _doRegisterGlobals(EObject source,XActiveRegisterGlobalsContext context)		
//	def void doRegisterGlobals(EObject source,XActiveRegisterGlobalsContext context)		
	def void _doRegisterGlobals(EObject source,XActiveRegisterGlobalsContext context)		
	def void doRegisterGlobals(EObject source,XActiveRegisterGlobalsContext context)		
}

interface XActiveCodeGenerationParticipant {
	def void _doCodeGeneration(EObject source,XActiveCodeGenerationContext context)		
	def void doCodeGeneration(EObject source,XActiveCodeGenerationContext context)		
}

abstract class XActiveAbstractElementProcessor 
implements XActiveRegisterGlobalsParticipant,XActiveTransformationParticipant<JvmIdentifiableElement>,XActiveCodeGenerationParticipant {
	
	public dispatch override doRegisterGlobals(EObject source, XActiveRegisterGlobalsContext context) {
	}
	
	override void doTransform(EObject source, JvmIdentifiableElement jvmTarget, XActiveTransformationContext context) {}
	
	public dispatch override  doCodeGeneration(EObject source, XActiveCodeGenerationContext context) {
	}
	
}

abstract class XActiveAbstractFieldProcessor 
implements XActiveRegisterGlobalsParticipant,XActiveTransformationParticipant<JvmField>,XActiveCodeGenerationParticipant {
	
	public dispatch override  doRegisterGlobals(EObject source, XActiveRegisterGlobalsContext context) {
	}
	
	override void doTransform(EObject source, JvmField jvmTarget, XActiveTransformationContext context) {}
	
	public dispatch override  doCodeGeneration(EObject source, XActiveCodeGenerationContext context) {
	}
	
}

abstract class XActiveAbstractMethodProcessor 
implements XActiveRegisterGlobalsParticipant,XActiveTransformationParticipant<JvmOperation>,XActiveCodeGenerationParticipant {
	
	public dispatch override  doRegisterGlobals(EObject source, XActiveRegisterGlobalsContext context) {	}
	
	override void doTransform(EObject source, JvmOperation jvmTarget, XActiveTransformationContext context) {}
	
	public dispatch override  doCodeGeneration(EObject source, XActiveCodeGenerationContext context) {	}
	
}

abstract class XActiveAbstractTypeProcessor 
implements XActiveRegisterGlobalsParticipant,XActiveTransformationParticipant<JvmDeclaredType>,XActiveCodeGenerationParticipant {
	
	public dispatch override  doRegisterGlobals(EObject source, XActiveRegisterGlobalsContext context) {	}
	
	override void doTransform(EObject source, JvmDeclaredType jvmTarget, XActiveTransformationContext context) {}
	
	public dispatch override  doCodeGeneration(EObject source, XActiveCodeGenerationContext context) {	}
	
}


