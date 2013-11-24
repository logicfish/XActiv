package com.logicfishsoftware.xtend.xactive.lib.annotations

import com.google.inject.Inject
import com.logicfishsoftware.commons.xtend.xannotation.AbstractMemberProcessor
import com.logicfishsoftware.xtend.xactive.lib.XActive
import com.logicfishsoftware.xtend.xactive.lib.XActiveAbstractElementProcessor
import com.logicfishsoftware.xtend.xactive.lib.XActiveTransformationContext
import java.lang.annotation.ElementType
import java.lang.annotation.Retention
import java.lang.annotation.RetentionPolicy
import java.lang.annotation.Target
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.RegisterGlobalsContext
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MemberDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableFieldDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableMemberDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.TypeReference
import org.eclipse.xtext.common.types.JvmIdentifiableElement

import static extension com.logicfishsoftware.commons.xtend.xannotation.Supertypes.*
import static extension com.logicfishsoftware.xtend.xactive.lib.annotations.ObjectFunctionSupport.*
import com.logicfishsoftware.xtend.xactive.lib.XActiveRegisterGlobalsContext
import org.eclipse.xtext.common.types.JvmField

@Active(ObjectFunctionProcessor)
@XActive(ObjectFunctionXProcessor)
@Target(#[ElementType.FIELD,ElementType.METHOD])
@Retention(RetentionPolicy.SOURCE)
annotation ObjectFunction {
	
}

class ObjectFunctionSupport {

	def static String nameOfFunction(MemberDeclaration m) { m.simpleName.toFirstUpper + "_Function"}
	
	def static String qualifiedNameOfFunction(MemberDeclaration m) { m.declaringType.qualifiedName + "." + m.nameOfFunction }

	def static String nameOfMethod(MemberDeclaration m) { m.simpleName.toFirstUpper + "_Function"}
		
}


class ObjectFunctionXProcessor extends XActiveAbstractElementProcessor {
	
	override doRegisterGlobals(EObject source, XActiveRegisterGlobalsContext context) {
		
	}
	
	override doTransform(EObject source, JvmIdentifiableElement jvmTarget, extension XActiveTransformationContext context) {
		
	}
	
}

class ObjectFunctionProcessor extends AbstractMemberProcessor {
	
	override doRegisterGlobals(MemberDeclaration annotatedMember, extension RegisterGlobalsContext context) {
		registerInterface(annotatedMember.qualifiedNameOfFunction);
	}

	def private objectInterface(MutableMemberDeclaration m) {
		m.declaringType.declaredInterfaces.findFirst[simpleName==m.nameOfFunction]
	}
	
	def void createObjectInterface(MutableMemberDeclaration declaration, TypeReference type, extension TransformationContext context) {
		val objectFunc = declaration.objectInterface()
		if(objectFunc==null) {
			context.addError(declaration,"Could not locate interface "+declaration.nameOfFunction)
			return;
		}
		declaration.declaringType.addSupertype(objectFunc,context)
		
		objectFunc.addMethod(declaration.nameOfMethod) [
			returnType=type
		]
	}
		
	def dispatch doTransform(MutableMethodDeclaration declaration, extension TransformationContext context) {
		val type = context.newTypeReference(declaration.returnType.type)
		declaration.createObjectInterface(type,context)
		
		declaration.declaringType.addMethod(declaration.nameOfMethod)[
			returnType=type
			body=[ "return "+declaration.simpleName + "();" ]
		]
	}
	


	
	def dispatch doTransform(MutableFieldDeclaration declaration, extension TransformationContext context) {
		val type = context.newTypeReference(declaration.type.type)
		declaration.createObjectInterface(type,context)

		declaration.declaringType.addMethod(declaration.nameOfMethod)[
			returnType=type
			body=[ "return "+declaration.simpleName + ";" ]
		]

	}

}


