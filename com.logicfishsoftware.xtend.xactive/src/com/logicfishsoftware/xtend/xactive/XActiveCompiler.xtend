package com.logicfishsoftware.xtend.xactive

import com.google.inject.ImplementedBy
import com.google.inject.Inject
import com.google.inject.name.Named
import com.logicfishsoftware.commons.emf.ECoreClasspathProvider
import com.logicfishsoftware.commons.emf.RuntimeInjectorProvider
import com.logicfishsoftware.commons.pde.log.Loggers
import com.logicfishsoftware.commons.xtend.annotations.Synchronize
import com.logicfishsoftware.xtend.xactive.lib.XActive
import com.logicfishsoftware.xtend.xactive.lib.XActiveCodeGenerationContext
import com.logicfishsoftware.xtend.xactive.lib.XActiveCodeGenerationParticipant
import com.logicfishsoftware.xtend.xactive.lib.XActiveRegisterGlobalsContext
import com.logicfishsoftware.xtend.xactive.lib.XActiveRegisterGlobalsParticipant
import com.logicfishsoftware.xtend.xactive.lib.XActiveTransformationContext
import com.logicfishsoftware.xtend.xactive.lib.XActiveTransformationParticipant
import java.lang.annotation.ElementType
import java.util.ArrayList
import java.util.Collections
import java.util.HashMap
import java.util.HashSet
import java.util.Map
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.common.types.JvmField
import org.eclipse.xtext.common.types.JvmFormalParameter
import org.eclipse.xtext.common.types.JvmIdentifiableElement
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmType
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation

import static com.logicfishsoftware.commons.xtend.Synchronization.*

interface XActiv {
	val ID = "com.logicfishsoftware.xtend.xactive"
}

@ImplementedBy(XActiveCompilerContextImpl)
interface XActiveCompilerContext {
	def void registerType(EObject eObject,Iterable<XAnnotation> anno,JvmType jvmTarget) 
	def void registerField(EObject eObject,Iterable<XAnnotation> anno,JvmField jvmTarget) 
	def void registerOperation(EObject eObject,Iterable<XAnnotation> anno,JvmOperation jvmTarget) 
	def void registerMethodParameter(EObject eObject,Iterable<XAnnotation> anno,JvmFormalParameter jvmTarget) 
	def void applyTransformation()
	
	def void register(EObject declaration, EList<XAnnotation> list, JvmIdentifiableElement member)
	
}

@ImplementedBy(typeof(XActiveCompilerImpl))
interface XActiveCompiler {
	def public XActiveCompilerContext createContext()
}

@ImplementedBy(XActiveContextImpl)
abstract class XActiveContext implements XActiveRegisterGlobalsContext,XActiveCodeGenerationContext,XActiveTransformationContext {
	
}

class XActiveContextImpl extends XActiveContext {
	
	override addError(EObject source, String error) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override addWarning(EObject source, String error) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
} 

package class XActiveProcessorImpl {
	@Inject extension ECoreClasspathProvider
	@Inject	@Named(XActiv.ID) extension RuntimeInjectorProvider
	
	Map<String,ClassLoader> mapClassloaders = Collections.synchronizedMap(new HashMap<String,ClassLoader>())	
	
	def <T> T getProcessor(XAnnotation annot) {
		val qualifiedName = annot.annotationType.qualifiedName
		
		if(qualifiedName==null||"void".equals(qualifiedName)) {
			return null
		}

		val classLoader = annot.getClassLoaderInternal()
		if(classLoader==null) {
			return null
		}
		
		val annoClass = classLoader.loadClass(qualifiedName)
		val c = classLoader.loadClass(typeof(XActive).name)  
		val xactiveAnnotation = annoClass.getAnnotation(c as Class<XActive>)
		try {
			xactiveAnnotation?.value?.newInstance() as T
		} catch(ClassCastException e) {
			null
		}
	}
	
	@Synchronize
	def getClassLoaderInternal(XAnnotation annotation) {
 		val uri = annotation.eResource.URI
		if(uri.segmentCount < 2) 
			return class.classLoader
			//return annotation.class.classLoader
		val project = uri.segment(1)
		if(mapClassloaders.containsKey(project)) {
			mapClassloaders.get(project)
		} else {
			mapClassloaders.put(project,getClassLoaderFor(class.classLoader,annotation))
		}
	}
	
	def <T> void withProcessor(XAnnotation anno,(T)=>void fnc) {
		try {
			val processor = <T>getProcessor(anno)
			if(processor!=null) {
				val i = getInjector()
				i?.injectMembers(processor)
				fnc.apply(processor)
			}
		} catch (Throwable e) {
			e.printStackTrace(System.err)
			Loggers::getLogger(XActiv.ID,typeof(XActiveProcessorImpl)).warn(e)
		}
	}
	
//	def lookupProcessor(XAnnotation annot) { mapProcessors.get(annot) }
	
//	@Synchronize
//	def void clearProcessorMappings() { mapClassloaders.clear }	
}

final class XActiveCompilerContextImpl extends XActiveProcessorImpl implements XActiveCompilerContext {
	@Inject
	XActiveContextImpl context
	
	val transformations = Collections.synchronizedList(new ArrayList<()=>void>()) 

	protected def <T extends EObject> eachContainer(Iterable<? extends T> obj,(T)=>void fnc) {
		val containers = new HashSet<EObject>
		obj.forEach[
			val container = it.eContainer
			if(!containers.contains(container)) {
				containers += container				
				fnc.apply(it as T)
			}
		]
		
	}
	
	protected def doRegisterGlobals(Iterable<XAnnotation> xAnnotations) {
		xAnnotations.eachContainer[
			EcoreUtil.resolveAll(it)
			val container = it.eContainer
			{<XActiveRegisterGlobalsParticipant>withProcessor[
					doRegisterGlobals(container,context)
				]}
		]
	}
	
	protected def doTransform(EObject eObject, Iterable<XAnnotation> anno, JvmIdentifiableElement jvmTarget) {
		for(it : anno) {
			<XActiveTransformationParticipant<JvmIdentifiableElement>>withProcessor[
				it.doTransform(eObject,jvmTarget,context)
			]
		}
	}
	
	protected def doCodeGeneration(Iterable<XAnnotation> xAnnotations) {
		xAnnotations.eachContainer[
			val a = it.eContainer
			{<XActiveCodeGenerationParticipant>withProcessor[
				doCodeGeneration(a,context)
			]}
		]
	}
	
	override applyTransformation() {
		val t = new ArrayList<()=>void>
		synchronize(transformations)[
			t.addAll(it)
			clear
		]
		t.forEach[apply]
	}

	def registerJvm(EObject eObject, Iterable<XAnnotation> annotations, JvmIdentifiableElement jvmTarget) {
		doRegisterGlobals(annotations)
		transformations += [|
			doTransform(eObject,annotations,jvmTarget)
			doCodeGeneration(annotations)
		]
	}
	
//	@Inject extension XAnnotationsInterpreter
//	@Inject extension TypeReferences
	
	def boolean annotationTargetMatches(XAnnotation annotation,ElementType type) {
//		val annotationType = annotation.annotationType as AnnotationTarget
//		(annotation.<Class<?>>getXAnnotationValue()?.name)
//		val ElementType[] types = annotation.<ElementType[]>getXAnnotationValue("value")
//		return types==null || types.empty || types.contains(type)
		true
	}
	
	override registerType(EObject eObject, Iterable<XAnnotation> anno, JvmType jvmTarget) {
		registerJvm(eObject,anno.filter[it.annotationTargetMatches(ElementType.TYPE)],jvmTarget)
	}
	
	override registerField(EObject eObject, Iterable<XAnnotation> anno, JvmField jvmTarget) {
		registerJvm(eObject,anno.filter[it.annotationTargetMatches(ElementType.FIELD)],jvmTarget)
	}
	
	override registerOperation(EObject eObject, Iterable<XAnnotation> anno, JvmOperation jvmTarget) {
		registerJvm(eObject,anno.filter[it.annotationTargetMatches(ElementType.METHOD)],jvmTarget)
	}
	
	override registerMethodParameter(EObject eObject, Iterable<XAnnotation> anno, JvmFormalParameter jvmTarget) {
		registerJvm(eObject,anno.filter[it.annotationTargetMatches(ElementType.PARAMETER)],jvmTarget)
	}

	def dispatch void register(EObject declaration, EList<XAnnotation> list, JvmIdentifiableElement element) {
		throw new IllegalArgumentException("Unsupported JvmIdentifiableElement type: "+element.qualifiedName)
	}
	def dispatch void register(EObject declaration, EList<XAnnotation> anno, JvmType type) {
		registerType(declaration,anno,type)
	}
	def dispatch void register(EObject declaration, EList<XAnnotation> anno, JvmField field) {
		registerField(declaration,anno,field)
	}
	def dispatch void register(EObject declaration, EList<XAnnotation> anno, JvmOperation operation) {
		registerOperation(declaration,anno,operation)
	}
	
}

class XActiveCompilerImpl implements XActiveCompiler {
	@Inject	@Named(XActiv.ID) extension RuntimeInjectorProvider
	override createContext() {
		return getInjector().getInstance(XActiveCompilerContext)
	}
}


