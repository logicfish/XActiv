package com.logicfishsoftware.xtend.xactive.lib.annotations

import com.google.inject.Inject
import com.logicfishsoftware.xtend.xactive.lib.XActive
import com.logicfishsoftware.xtend.xactive.lib.XActiveAbstractFieldProcessor
import com.logicfishsoftware.xtend.xactive.lib.XActiveTransformationContext
import java.lang.annotation.ElementType
import java.lang.annotation.Retention
import java.lang.annotation.RetentionPolicy
import java.lang.annotation.Target
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.macro.AbstractFieldProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableFieldDeclaration
import org.eclipse.xtext.common.types.JvmField
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder

@XActive(GetterAndSetterXProcessor)
@Active(GetterAndSetterProcessor)
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.SOURCE)
annotation GetterAndSetter {
}
class GetterAndSetterXProcessor extends XActiveAbstractFieldProcessor {
	@Inject extension JvmTypesBuilder
	
	override doTransform(EObject source, JvmField field, extension XActiveTransformationContext context) {
		field.declaringType => [
			members += toGetter(source,field.simpleName,field.type)
			members += toSetter(source,field.simpleName,field.type)		
		]		
	}
	
}

class GetterAndSetterProcessor extends AbstractFieldProcessor {
	
	override doTransform(MutableFieldDeclaration annotatedField, extension TransformationContext context) {
		val simpleName = annotatedField.simpleName
		annotatedField.declaringType.addMethod("get" + simpleName.toFirstUpper)[
			returnType = annotatedField.type.type.newTypeReference()
			body = [ "return this." + simpleName +";"]
		]
		annotatedField.declaringType.addMethod("set" + annotatedField.simpleName.toFirstUpper)[
			returnType = typeof(void).findTypeGlobally.newTypeReference
			addParameter(simpleName,annotatedField.type.type.newTypeReference)
			body = [
				'''this.«simpleName» =  «simpleName»;'''
			]
		]
	}
	
}
