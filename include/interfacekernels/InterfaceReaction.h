//* This file is revised from interfacediffusion

#ifndef INTERFACEREACTION_H
#define INTERFACEREACTION_H

#include "InterfaceKernel.h"

// Forward Declarations
class InterfaceReaction;

template <>
InputParameters validParams<InterfaceReaction>();

/**
 * DG kernel for interfacing reaction between two variables on adjacent blocks
 */
class InterfaceReaction : public InterfaceKernel
{
public:
  InterfaceReaction(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual(Moose::DGResidualType type) override;
  virtual Real computeQpJacobian(Moose::DGJacobianType type) override;

  Real _k1;
  Real _k2;
  const MaterialProperty<Real> & _D;
  const MaterialProperty<Real> & _D_neighbor;
};
  
  //Real _k1;
  //Real _k2;

#endif
