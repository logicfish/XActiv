package com.logicfishsoftware.example.xactive.domainmodel.tests.annotations

import com.google.inject.Inject
import com.logicfishsoftware.xtend.xactive.lib.XActive
import com.logicfishsoftware.xtend.xactive.lib.XActiveAbstractMethodProcessor
import com.logicfishsoftware.xtend.xactive.lib.XActiveAbstractTypeProcessor
import com.logicfishsoftware.xtend.xactive.lib.XActiveTransformationContext
import java.lang.annotation.ElementType
import java.lang.annotation.Retention
import java.lang.annotation.RetentionPolicy
import java.lang.annotation.Target
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.util.TypeReferences
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder

@XActive(typeof(TestXActiveProcessor))
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.SOURCE)
annotation TestXActive {
	Class<?> value=typeof(Object)
	String body=""
}

class TestXActiveProcessor extends XActiveAbstractTypeProcessor {

  @Inject extension TypeReferences

  @Inject extension JvmTypesBuilder

  override void doTransform(EObject source, JvmDeclaredType jvmTarget, extension XActiveTransformationContext context) {
		val XAnnotation annotation = source.eContents.filter(typeof(XAnnotation)).filter[annotationType.qualifiedName==typeof(TestXActive).name]?.head
		jvmTarget => [
			members += annotation.toField("xActiveTest",typeof(Integer).getTypeForName(source))[
				documentation = "TEST!!!"
  	 			initializer = [ append("200") ]
			]
		]
  }

}


@XActive(value=typeof(TestXActiveMethodProcessor),opaque=false)
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
annotation TestXActiveMethod {
	Class<?> value=typeof(Object)
	String body=""
}

class TestXActiveMethodProcessor extends XActiveAbstractMethodProcessor {

  @Inject extension TypeReferences

  @Inject extension JvmTypesBuilder

  override void doTransform(EObject source, JvmOperation jvmTarget, extension XActiveTransformationContext context) {
		jvmTarget => [
			returnType = typeof(List).getTypeForName(source) 
			body = [ append('''return null;''') ]
		]
  }
	
}