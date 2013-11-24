/**
 */
package com.logicfishsoftware.example.xactive.domainmodel.domainmodel;

import org.eclipse.emf.common.util.EList;

import org.eclipse.xtext.common.types.JvmParameterizedTypeReference;
import org.eclipse.xtext.common.types.JvmTypeParameter;

import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Entity</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link com.logicfishsoftware.example.xactive.domainmodel.domainmodel.Entity#getAnnotations <em>Annotations</em>}</li>
 *   <li>{@link com.logicfishsoftware.example.xactive.domainmodel.domainmodel.Entity#getSuperTypes <em>Super Types</em>}</li>
 *   <li>{@link com.logicfishsoftware.example.xactive.domainmodel.domainmodel.Entity#getTypeParameters <em>Type Parameters</em>}</li>
 *   <li>{@link com.logicfishsoftware.example.xactive.domainmodel.domainmodel.Entity#getFeatures <em>Features</em>}</li>
 * </ul>
 * </p>
 *
 * @see com.logicfishsoftware.example.xactive.domainmodel.domainmodel.DomainmodelPackage#getEntity()
 * @model
 * @generated
 */
public interface Entity extends AbstractElement
{
  /**
   * Returns the value of the '<em><b>Annotations</b></em>' containment reference list.
   * The list contents are of type {@link org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Annotations</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Annotations</em>' containment reference list.
   * @see com.logicfishsoftware.example.xactive.domainmodel.domainmodel.DomainmodelPackage#getEntity_Annotations()
   * @model containment="true"
   * @generated
   */
  EList<XAnnotation> getAnnotations();

  /**
   * Returns the value of the '<em><b>Super Types</b></em>' containment reference list.
   * The list contents are of type {@link org.eclipse.xtext.common.types.JvmParameterizedTypeReference}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Super Types</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Super Types</em>' containment reference list.
   * @see com.logicfishsoftware.example.xactive.domainmodel.domainmodel.DomainmodelPackage#getEntity_SuperTypes()
   * @model containment="true"
   * @generated
   */
  EList<JvmParameterizedTypeReference> getSuperTypes();

  /**
   * Returns the value of the '<em><b>Type Parameters</b></em>' containment reference list.
   * The list contents are of type {@link org.eclipse.xtext.common.types.JvmTypeParameter}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Type Parameters</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Type Parameters</em>' containment reference list.
   * @see com.logicfishsoftware.example.xactive.domainmodel.domainmodel.DomainmodelPackage#getEntity_TypeParameters()
   * @model containment="true"
   * @generated
   */
  EList<JvmTypeParameter> getTypeParameters();

  /**
   * Returns the value of the '<em><b>Features</b></em>' containment reference list.
   * The list contents are of type {@link com.logicfishsoftware.example.xactive.domainmodel.domainmodel.Feature}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Features</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Features</em>' containment reference list.
   * @see com.logicfishsoftware.example.xactive.domainmodel.domainmodel.DomainmodelPackage#getEntity_Features()
   * @model containment="true"
   * @generated
   */
  EList<Feature> getFeatures();

} // Entity
