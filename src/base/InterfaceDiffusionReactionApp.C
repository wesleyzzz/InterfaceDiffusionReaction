#include "InterfaceDiffusionReactionApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<InterfaceDiffusionReactionApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

InterfaceDiffusionReactionApp::InterfaceDiffusionReactionApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  InterfaceDiffusionReactionApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  InterfaceDiffusionReactionApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  InterfaceDiffusionReactionApp::registerExecFlags(_factory);
}

InterfaceDiffusionReactionApp::~InterfaceDiffusionReactionApp() {}

void
InterfaceDiffusionReactionApp::registerApps()
{
  registerApp(InterfaceDiffusionReactionApp);
}

void
InterfaceDiffusionReactionApp::registerObjects(Factory & factory)
{
    Registry::registerObjectsTo(factory, {"InterfaceDiffusionReactionApp"});
}

void
InterfaceDiffusionReactionApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & action_factory)
{
  Registry::registerActionsTo(action_factory, {"InterfaceDiffusionReactionApp"});

  /* Uncomment Syntax parameter and register your new production objects here! */
}

void
InterfaceDiffusionReactionApp::registerObjectDepends(Factory & /*factory*/)
{
}

void
InterfaceDiffusionReactionApp::associateSyntaxDepends(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}

void
InterfaceDiffusionReactionApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execution flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
InterfaceDiffusionReactionApp__registerApps()
{
  InterfaceDiffusionReactionApp::registerApps();
}

extern "C" void
InterfaceDiffusionReactionApp__registerObjects(Factory & factory)
{
  InterfaceDiffusionReactionApp::registerObjects(factory);
}

extern "C" void
InterfaceDiffusionReactionApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  InterfaceDiffusionReactionApp::associateSyntax(syntax, action_factory);
}

extern "C" void
InterfaceDiffusionReactionApp__registerExecFlags(Factory & factory)
{
  InterfaceDiffusionReactionApp::registerExecFlags(factory);
}
