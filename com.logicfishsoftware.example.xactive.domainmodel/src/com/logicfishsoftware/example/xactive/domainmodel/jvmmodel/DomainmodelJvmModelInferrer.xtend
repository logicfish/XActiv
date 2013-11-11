package com.logicfishsoftware.example.xactive.domainmodel.jvmmodel

import com.google.inject.Inject
import com.logicfishsoftware.example.xactive.domainmodel.domainmodel.Entity
import com.logicfishsoftware.example.xactive.domainmodel.domainmodel.Operation
import com.logicfishsoftware.example.xactive.domainmodel.domainmodel.Property
import com.logicfishsoftware.xtend.xactive.XActiveCompiler
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1

class DomainmodelJvmModelInferrer extends AbstractModelInferrer {
	
	@Inject extension JvmTypesBuilder
	@Inject extension IQualifiedNameProvider
	@Inject XActiveCompiler xActiv

	def dispatch infer(Entity entity, IJvmDeclaredTypeAcceptor acceptor, boolean prelinkingPhase) {
		val xActiveContext = xActiv.createContext()
		
		acceptor.accept(
			entity.toClass( entity.fullyQualifiedName )
		).initializeLater [
			documentation = entity.documentation
			if (entity.superTypes != null) {
				for(superType : entity.superTypes) {
					superTypes += superType.cloneWithProxies
				}
			}
				

			if(entity.typeParameters!=null) {
				for(typeParameter : entity.typeParameters) {
					it.copyTypeParameter(typeParameter)
				}
			}

			val procedure = entity.newTypeRef(Procedure1, it.newTypeRef())
			members += entity.toConstructor() []
			members += entity.toConstructor() [
				parameters += entity.toParameter("initializer", procedure)
				body = [it.append("initializer.apply(this);")]
			]
			xActiveContext?.registerType(entity,entity.annotations,it)
			for ( f : entity.features ) {
				switch f {
			
					Property : {
						val field = f.toField(f.name, f.type)[
							xActiveContext?.registerField(f,f.annotations,it)
							f.annotations.translateAnnotationsTo(it)
							documentation = f.documentation
						]
						members += field
						members += f.toGetter(f.name, f.type)
						members += f.toSetter(f.name, f.type)
					}
			
					Operation : {
						members += f.toMethod(f.name, f.type ?: inferredType) [
							xActiveContext?.registerOperation(f,f.annotations,it)
							documentation = f.documentation
							if(f.typeParameters!=null) {
								for(typeParameter : f.typeParameters) {
									copyTypeParameter(typeParameter)
								}
							}

							for (p : f.params) {
								parameters += p.toParameter(p.name, p.parameterType)
							}
							body = f.body
							f.annotations.translateAnnotationsTo(it)
						]
					}
				}
			}
			members += entity.toToStringMethod(it)
			entity.annotations.translateAnnotationsTo(it)
			xActiveContext?.applyTransformation
		]
	}
	
	def void copyTypeParameter(JvmTypeParameterDeclarator declarator,JvmTypeParameter typeParameter) {
			val jvmTypeParameter = typeParameter.cloneWithProxies
			jvmTypeParameter.declarator = declarator
			declarator.typeParameters += jvmTypeParameter
	}
	
}