# GettingStarted
If you're not sure what to do, start here!

## TO DO
Add deployment to create resources and the necessary information here.

# Developer Getting Started
There are four projects; 
- Getting Started focuses on getting the infrastructure created in the least amount of effort.  This will include scripts, ARM templates, and documents.
- CoraBot contains the code for the bot and the messaging.
- Website has the web site code.
- DataModel, will eventually have a generalized data interface.  NYI

The basic workflow is to make a fork of the project that you are working on and when done submit a PR back.

## Working with CoraBot
To get up and developing on the CoraBot you will need:
- Clone the CoraBot repo, or you fork of it.
- Clone the Bot Framework from here: https://github.com/Microsoft/botbuilder-dotnet/#packages
- Install the Bot emulator from here: https://github.com/Microsoft/BotFramework-Emulator/releases/tag/v4.9.0
- Install the CosmosDB emulator from here: https://aka.ms/cosmosdb-emulator

Environment:
- Set the solution configuration to debug which will use the already set appsettings.Development.json
- Set the Startup project to Bot.
- Start the Cosmos DB emulator
- Start the Bot Framework Emulator.

### First time
- Go ahead and open the MasterDialog.cs and add a breakpoint at line 35.
- Hit F5 to start debugging, the localhost:5001 will open the browser with a not found error.
- Open the Bot Emulator, select Open Bot, enter http://localhost:5001/api/Messages and Connect.
- Type a message and the breakpoint should be hit.  

####Congratulations you are up and running!

## Working with Website

For the website contact on we are using the DotNetCoreReactImplementation.  

## Working with DataModel

NYI

## Working with GettingStarted

In progress