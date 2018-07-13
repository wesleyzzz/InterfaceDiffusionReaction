//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef INTERFACE_DIFFUSION_REACTIONTESTAPP_H
#define INTERFACE_DIFFUSION_REACTIONTESTAPP_H

#include "MooseApp.h"

class InterfaceDiffusionReactionTestApp;

template <>
InputParameters validParams<InterfaceDiffusionReactionTestApp>();

class InterfaceDiffusionReactionTestApp : public MooseApp
{
public:
  InterfaceDiffusionReactionTestApp(InputParameters parameters);
  virtual ~InterfaceDiffusionReactionTestApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
  static void registerExecFlags(Factory & factory);
};

#endif /* INTERFACE_DIFFUSION_REACTIONTESTAPP_H */
