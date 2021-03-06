
#include "InterfaceReactionFlux.h"

registerMooseObject("InterfaceDiffusionReactionApp", InterfaceReactionFlux);

template <>
InputParameters
validParams<InterfaceReactionFlux>()
{
  InputParameters params = validParams<InterfaceKernel>(); 
  params.addParam<MaterialPropertyName>("D", "D", "The diffusion coefficient.");
  params.addParam<MaterialPropertyName>(
      "D_neighbor", "D_neighbor", "The neighboring diffusion coefficient.");
  params.addRequiredParam<Real>("kf", "Forward reaction rate coefficient.");
  params.addRequiredParam<Real>("kb", "Backward reaction rate coefficient.");
  params.addClassDescription("Implements a reaction to establish flux=kf*u-kb*v "
                             "at interface.");
  return params;
}

InterfaceReactionFlux::InterfaceReactionFlux(const InputParameters & parameters)
  : InterfaceKernel(parameters), 
    _kf(getParam<Real>("kf")),
    _kb(getParam<Real>("kb")),
    _D(getMaterialProperty<Real>("D")),
    _D_neighbor(getNeighborMaterialProperty<Real>("D_neighbor"))
{
}

Real
InterfaceReactionFlux::computeQpResidual(Moose::DGResidualType type) 
{
  Real r = 0;

  switch (type)
  {
    
    //Move all the terms to the LHS to get residual, for master domain
    //  R = flux - kf*u + kb*v = (-D*grad(u))_from_neighbor - kf*u + kb*v
    //Weak form for master domain is: -(test, n*(D*grad(u))_from_neighbor + kf*u - kb*v)

    case Moose::Element:
	  r = -_test[_i][_qp] * (_D_neighbor[_qp] * _grad_neighbor_value[_qp] * _normals[_qp] + _kf * _u[_qp] - _kb * _neighbor_value[_qp]);
      break;

    //Similarly, weak form for slave domain is: (test, n*(D*grad(u))_from_master + kf*u - kb*v), flip the sign because the direction is opposite.
    case Moose::Neighbor:
      r = _test_neighbor[_i][_qp] * (_D[_qp] * _grad_u[_qp] * _normals[_qp] + _kf * _u[_qp]- _kb * _neighbor_value[_qp]);
      break;

  }

  return r;

}

Real
InterfaceReactionFlux::computeQpJacobian(Moose::DGJacobianType type)
{
  Real jac = 0;

  switch (type)
  {
    case Moose::ElementElement:
      jac = -_test[_i][_qp] * _kf * _phi[_j][_qp];
      break;

    case Moose::NeighborNeighbor:
      jac = _test_neighbor[_i][_qp] * - _kb * _phi_neighbor[_j][_qp];
      break;

    case Moose::NeighborElement:
      jac = _test_neighbor[_i][_qp] * (_D[_qp] * _grad_phi[_j][_qp] * _normals[_qp] + _kf * _phi[_j][_qp]);
      break;

    case Moose::ElementNeighbor:
      jac = -_test[_i][_qp] * (_D_neighbor[_qp] * _grad_phi_neighbor[_j][_qp] * _normals[_qp] - _kb * _phi_neighbor[_j][_qp]);
      break;
  }

  return jac;
}
