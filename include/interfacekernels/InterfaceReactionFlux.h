//* This file is revised from interfacediffusion

#ifndef INTERFACEREACTIONFLUX_H
#define INTERFACEREACTIONFLUX_H

#include "InterfaceKernel.h"

// Forward Declarations
class InterfaceReactionFlux;

template <>
InputParameters validParams<InterfaceReactionFlux>();

/**
 * DG kernel for interfacing reaction between two variables on adjacent blocks
 */
class InterfaceReactionFlux : public InterfaceKernel
{
public:
  InterfaceReactionFlux(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual(Moose::DGResidualType type) override;
  virtual Real computeQpJacobian(Moose::DGJacobianType type) override;

  Real _kf;
  Real _kb;
  const MaterialProperty<Real> & _D;
  const MaterialProperty<Real> & _D_neighbor;
};

#endif
