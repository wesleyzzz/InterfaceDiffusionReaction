//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "InterfaceDiffusionReactionTestApp.h"
#include "InterfaceDiffusionReactionApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<InterfaceDiffusionReactionTestApp>()
{
  InputParameters params = validParams<InterfaceDiffusionReactionApp>();
  return params;
}

InterfaceDiffusionReactionTestApp::InterfaceDiffusionReactionTestApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  InterfaceDiffusionReactionApp::registerObjectDepends(_factory);
  InterfaceDiffusionReactionApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  InterfaceDiffusionReactionApp::associateSyntaxDepends(_syntax, _action_factory);
  InterfaceDiffusionReactionApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  InterfaceDiffusionReactionApp::registerExecFlags(_factory);

  bool use_test_objs = getParam<bool>("allow_test_objects");
  if (use_test_objs)
  {
    InterfaceDiffusionReactionTestApp::registerObjects(_factory);
    InterfaceDiffusionReactionTestApp::associateSyntax(_syntax, _action_factory);
    InterfaceDiffusionReactionTestApp::registerExecFlags(_factory);
  }
}

InterfaceDiffusionReactionTestApp::~InterfaceDiffusionReactionTestApp() {}

void
InterfaceDiffusionReactionTestApp::registerApps()
{
  registerApp(InterfaceDiffusionReactionApp);
  registerApp(InterfaceDiffusionReactionTestApp);
}

void
InterfaceDiffusionReactionTestApp::registerObjects(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new test objects here! */
}

void
InterfaceDiffusionReactionTestApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
  /* Uncomment Syntax and ActionFactory parameters and register your new test objects here! */
}

void
InterfaceDiffusionReactionTestApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execute flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
InterfaceDiffusionReactionTestApp__registerApps()
{
  InterfaceDiffusionReactionTestApp::registerApps();
}

// External entry point for dynamic object registration
extern "C" void
InterfaceDiffusionReactionTestApp__registerObjects(Factory & factory)
{
  InterfaceDiffusionReactionTestApp::registerObjects(factory);
}

// External entry point for dynamic syntax association
extern "C" void
InterfaceDiffusionReactionTestApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  InterfaceDiffusionReactionTestApp::associateSyntax(syntax, action_factory);
}

// External entry point for dynamic execute flag loading
extern "C" void
InterfaceDiffusionReactionTestApp__registerExecFlags(Factory & factory)
{
  InterfaceDiffusionReactionTestApp::registerExecFlags(factory);
}
