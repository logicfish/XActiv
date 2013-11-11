package com.logicfishsoftware.xtend.xactive.lib.annotations

import com.google.inject.Inject
import com.logicfishsoftware.commons.xtend.xannotation.XAnnotationsInterpreter
import com.logicfishsoftware.xtend.xactive.lib.XActive
import com.logicfishsoftware.xtend.xactive.lib.XActiveAbstractElementProcessor
import com.logicfishsoftware.xtend.xactive.lib.XActiveTransformationContext
import java.lang.annotation.ElementType
import java.lang.annotation.Retention
import java.lang.annotation.RetentionPolicy
import java.lang.annotation.Target
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmField
import org.eclipse.xtext.common.types.JvmIdentifiableElement
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmType
import org.eclipse.xtext.common.types.JvmVoid
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder

import static extension com.logicfishsoftware.commons.xtend.CommonsCollections.*

/**
 * Create an anonymous instance of type 'value', using the optional type parameters. The optional mixin string
 * is used as the constructor parameter list.
 */
@XActive(typeof(AnonymousInnerTypeXProcessor))
@Target(#[ElementType.FIELD,ElementType.METHOD])
@Retention(RetentionPolicy.SOURCE)
annotation AnonymousInnerType {
	Class<?> value=typeof(Object)
	Class<?>[] typeParam=#[]
	String[] typeParamS=#[]
	String[] ctorParam=#[]
	String mixin=""
}

class AnonymousInnerTypeXProcessor extends XActiveAbstractElementProcessor {
	@Inject extension JvmTypesBuilder

	override void doTransform(EObject source, JvmIdentifiableElement jvmTarget, XActiveTransformationContext context) {
		val XAnnotation annotation = source.eContents.filter(typeof(XAnnotation))?.filter[annotationType.qualifiedName==typeof(AnonymousInnerType).name]?.head
		if(annotation==null) throw new IllegalArgumentException(
			'''Could not locate XAnnotation for EObject [«source.toString»]'''
			)
		doTransformInternal(source,annotation,jvmTarget,context)
	}
	
	def dispatch void doTransformInternal(EObject source, XAnnotation annotation,JvmIdentifiableElement jvmTarget, XActiveTransformationContext context) {
	}
	def dispatch void doTransformInternal(EObject source, XAnnotation annotation, JvmField jvmTarget, XActiveTransformationContext context) {
		jvmTarget.initializer = [it.append(annotation.buildAnonymousInner(jvmTarget.type.type,context))]
	}
	    
	def dispatch void doTransformInternal(EObject source, XAnnotation annotation,JvmOperation jvmTarget, XActiveTransformationContext context) {
		jvmTarget.body = [
			append("return " + annotation.buildAnonymousInner(jvmTarget.returnType.type,context) + ";")
		]
	}

	@Inject extension XAnnotationsInterpreter

	def buildAnonymousInner(XAnnotation annotation,JvmType type,extension XActiveTransformationContext context) {
		val qName = (annotation.<Class<?>>getXAnnotationValue()?.name)?:type.qualifiedName
		val param = annotation.<Class<?>[]>getXAnnotationValue("typePrarm")?.map[it.name]
		val paramS = annotation.<Object[]>getXAnnotationValue("typeParamS")
		val ctorParam = annotation.<Object[]>getXAnnotationValue("ctorParam")
		val mixin = annotation.<String>getXAnnotationValue("mixin")
		
		'''	new «qName» 
				«IF param!=null && !param.empty»<«param.toCSVString»>«ELSEIF paramS!=null && !paramS.empty»<«paramS.toCSVString»>«ENDIF»
				(«ctorParam.toCSVString?:""»)
				{«mixin»}
		''' //.toString.trim
		
//		val typeParam = if(param == null || param.empty) { "" } else { "<" + param.toCSVString() + ">"}
//		return (if(type instanceof JvmVoid)""else "return ") + "new " + qName + typeParam + "(" + (ctorParam?.toCSVString()?:"") + "){" + (mixin?:"") + "}"
	}
}