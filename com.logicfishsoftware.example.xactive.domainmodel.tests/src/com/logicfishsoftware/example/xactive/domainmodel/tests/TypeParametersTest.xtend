package com.logicfishsoftware.example.xactive.domainmodel.tests

import com.google.inject.Inject
import com.logicfishsoftware.example.xactive.domainmodel.DomainmodelInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

@InjectWith(DomainmodelInjectorProvider)
@RunWith(XtextRunner)
class AnnotationTests {
    @Inject extension CompilationTestHelper



	@Test
	def void testParametizedType() {
		'''
entity Foo<X,Y> {
	
	myField : String
	
}
		'''	.assertCompilesTo('''
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.eclipse.xtext.xbase.lib.util.ToStringHelper;

@SuppressWarnings("all")
public class Foo<X, Y> {
  public Foo() {
  }
  
  public Foo(final Procedure1<Foo<X,Y>> initializer) {
    initializer.apply(this);
  }
  
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
	def void testMethodTypeParameters() {
		'''
entity Foo {
	
	op <X,Y> myField () : String { }
	
}
		'''	.assertCompilesTo('''
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.eclipse.xtext.xbase.lib.util.ToStringHelper;

@SuppressWarnings("all")
public class Foo {
  public Foo() {
  }
  
  public Foo(final Procedure1<Foo> initializer) {
    initializer.apply(this);
  }
  
  public <X, Y> String myField() {
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

}