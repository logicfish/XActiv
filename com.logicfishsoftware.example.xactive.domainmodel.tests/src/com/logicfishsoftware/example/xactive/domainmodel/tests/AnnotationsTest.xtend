package com.logicfishsoftware.example.xactive.domainmodel.tests

import com.google.inject.Inject
import com.logicfishsoftware.example.xactive.domainmodel.DomainmodelInjectorProvider
import com.logicfishsoftware.example.xactive.domainmodel.tests.annotations.SynchronizeTest
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import com.logicfishsoftware.example.xactive.domainmodel.tests.annotations.TestXActive
import com.logicfishsoftware.example.xactive.domainmodel.tests.annotations.ExportedClass
import com.logicfishsoftware.example.xactive.domainmodel.tests.annotations.TestClassParam
import java.util.HashMap
import com.logicfishsoftware.example.xactive.domainmodel.tests.annotations.TestClassParamMethod
import java.util.HashSet

@InjectWith(DomainmodelInjectorProvider)
@RunWith(XtextRunner)
class AnnotationsTest {
    @Inject extension CompilationTestHelper

	@Test
	def void testCompilerCanLoadTestClasses(){
		'''
entity Foo {
	
	myVar : «typeof(ExportedClass).name» 
	op bar() { return "Bar" }
	
}
		'''	.assertCompilesTo('''
import com.logicfishsoftware.example.xactive.domainmodel.tests.annotations.ExportedClass;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.eclipse.xtext.xbase.lib.util.ToStringHelper;

@SuppressWarnings("all")
public class Foo {
  public Foo() {
  }
  
  public Foo(final Procedure1<Foo> initializer) {
    initializer.apply(this);
  }
  
  private ExportedClass myVar;
  
  public ExportedClass getMyVar() {
    return this.myVar;
  }
  
  public void setMyVar(final ExportedClass myVar) {
    this.myVar = myVar;
  }
  
  public String bar() {
    return "Bar";
  }
  
  @Override
  public String toString() {
    String result = new ToStringHelper().toString(this);
    return result;
  }
}
		''')
		
	}

	@Test
	def void testSynchronize() {
		'''
entity Foo {
	
	@«typeof(SynchronizeTest).name»
	op bar() { return "Bar" }
	
}
		'''	.assertCompilesTo('''
import com.logicfishsoftware.example.xactive.domainmodel.tests.annotations.SynchronizeTest;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.eclipse.xtext.xbase.lib.util.ToStringHelper;

@SuppressWarnings("all")
public class Foo {
  public Foo() {
  }
  
  public Foo(final Procedure1<Foo> initializer) {
    initializer.apply(this);
  }
  
  @SynchronizeTest
  public synchronized String bar() {
    return "Bar";
  }
  
  @Override
  public String toString() {
    String result = new ToStringHelper().toString(this);
    return result;
  }
}
		''')
	}
	@Test
	def void testFieldAnnotation() {
		'''
entity Foo {
	
	@«typeof(TestClassParam).name»(typeof(«typeof(HashMap).name»))
	myField : String
	
}
		'''	.assertCompilesTo('''
import com.logicfishsoftware.example.xactive.domainmodel.tests.annotations.TestClassParam;
import java.util.HashMap;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.eclipse.xtext.xbase.lib.util.ToStringHelper;

@SuppressWarnings("all")
public class Foo {
  public Foo() {
  }
  
  public Foo(final Procedure1<Foo> initializer) {
    initializer.apply(this);
  }
  
  /**
   * Type found: java.util.HashMap
   */
  @TestClassParam(HashMap.class)
  private String myField;
  
  public String getMyField() {
    return this.myField;
  }
  
  public void setMyField(final String myField) {
    this.myField = myField;
  }
  
  @Override
  public String toString() {
    String result = new ToStringHelper().toString(this);
    return result;
  }
}
		''')
	}
	@Test
	def void testMethodAnnotation() {
		'''
entity Foo {
	
	@«typeof(TestClassParamMethod).name»(typeof(«typeof(HashSet).name»))
	op myField () : String { }
	
}
		'''	.assertCompilesTo('''
import com.logicfishsoftware.example.xactive.domainmodel.tests.annotations.TestClassParamMethod;
import java.util.HashSet;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.eclipse.xtext.xbase.lib.util.ToStringHelper;

@SuppressWarnings("all")
public class Foo {
  public Foo() {
  }
  
  public Foo(final Procedure1<Foo> initializer) {
    initializer.apply(this);
  }
  
  /**
   * Type found: java.util.HashSet
   */
  @TestClassParamMethod(HashSet.class)
  public String myField() {
    return null;
  }
  
  @Override
  public String toString() {
    String result = new ToStringHelper().toString(this);
    return result;
  }
}
		''')
	}

	@Test
	def void testXActive() {
		'''
@«typeof(TestXActive).name»
entity Foo {
	
	op bar() { return "Bar" }
	
}
		'''	.assertCompilesTo('''
import com.logicfishsoftware.example.xactive.domainmodel.tests.annotations.TestXActive;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.eclipse.xtext.xbase.lib.util.ToStringHelper;

@TestXActive
@SuppressWarnings("all")
public class Foo {
  public Foo() {
  }
  
  public Foo(final Procedure1<Foo> initializer) {
    initializer.apply(this);
  }
  
  public String bar() {
    return "Bar";
  }
  
  @Override
  public String toString() {
    String result = new ToStringHelper().toString(this);
    return result;
  }
  
  /**
   * TEST!!!
   */
  private Integer xActiveTest = 200;
}
		''')
	}
}