<div>
    <img src="https://raw.githubusercontent.com/fitability/.github/main/assets/github-repo-api-3840x1920.png" width="240" height="120">
</div>

# API for fitability:tm: #

[![Build: User API](https://github.com/fitability/fitability-api/actions/workflows/user-build.yaml/badge.svg?branch=main)](https://github.com/fitability/fitability-api/actions/workflows/user-build.yaml)
[![Build: Workout API](https://github.com/fitability/fitability-api/actions/workflows/workout-build.yaml/badge.svg?branch=main)](https://github.com/fitability/fitability-api/actions/workflows/workout-build.yaml)

This provides APIs for all fitability:tm: apps.


## Prerequisites ##

This repository contains all API apps written in different languages including C# and Java. All API apps are running on [Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-overview?WT.mc_id=dotnet-55788-juyoo). Therefore, setting up the development environment to locally run all Azure Functions apps is critical.

Depending on your developer expertise, you may be required to install some or all of the following IDE and tools to locally develop API applications.


### For .NET ###

For .NET-based API apps, you must install the following IDE and SDK.

* [.NET 6 SDK](https://dotnet.microsoft.com/download/dotnet/6.0?WT.mc_id=dotnet-55788-juyoo)
* [Visual Studio](https://visualstudio.microsoft.com/vs?WT.mc_id=dotnet-55788-juyoo)
* [Visual Studio Code](https://code.visualstudio.com?WT.mc_id=dotnet-55788-juyoo)
* [Visual Studio Code Extension: C#](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp&WT.mc_id=dotnet-55788-juyoo)
* [Visual Studio Code Extension: Azure Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-node-azure-pack&WT.mc_id=dotnet-55788-juyoo)
* [Azure Functions Core Tools](https://docs.microsoft.com/azure/azure-functions/functions-run-local?WT.mc_id=dotnet-55788-juyoo)
* [Azurite: Local Azure Storage Emulator](https://docs.microsoft.com/azure/storage/common/storage-use-azurite?WT.mc_id=dotnet-55788-juyoo)

If you are new to .NET-based Azure Functions app, please read this doc, [Develop C# class library functions using Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-dotnet-class-library?WT.mc_id=dotnet-55788-juyoo), first and get yourself used to it.


### For Java ###

For Java-based API apps, you must install the following IDE and SDK.

* [Microsoft Build of OpenJDK 17](https://docs.microsoft.com/java/openjdk/download?WT.mc_id=dotnet-55788-juyoo#openjdk-17)
* [Apache Maven](https://maven.apache.org/download.cgi)
* [Azure Functions Core Tools](https://docs.microsoft.com/azure/azure-functions/functions-run-local?WT.mc_id=dotnet-55788-juyoo)
* [Azurite: Local Azure Storage Emulator](https://docs.microsoft.com/azure/storage/common/storage-use-azurite?WT.mc_id=dotnet-55788-juyoo)

There are many options for you to choose an IDE. If you want to use JetBrains' IntelliJ IDEA:

* [IntelliJ IDEA](https://www.jetbrains.com/idea/download)
* [IntelliJ IDEA Plugin: Azure Toolkit for IntelliJ](https://plugins.jetbrains.com/plugin/8053-azure-toolkit-for-intellij)

If you prefer using Visual Studio Code:

* [Visual Studio Code](https://code.visualstudio.com?WT.mc_id=dotnet-55788-juyoo)
* [Visual Studio Code Extension: Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack&WT.mc_id=dotnet-55788-juyoo)

If you are new to Java-based Azure Functions app, please read this doc, [Azure Functions Java developer guide](https://docs.microsoft.com/azure/azure-functions/functions-reference-java?WT.mc_id=dotnet-55788-juyoo), first and get yourself used to it.

> **NOTE**: Although the document above says that the Azure Functions v4 runtime supports both Java 8 and 11, our APIs are targeting Java 8, due to some limitations as of January 2022. We will continue to investigate when to migrate to Jave 11 or higher.


### For Azure Resources ###

For Azure resources, you are strongly recommended to install the following IDE, extensions and tools.

* [Free Azure Account for 30 Days](https://azure.microsoft.com/free?WT.mc_id=dotnet-55788-juyoo)
* [Visual Studio Code](https://code.visualstudio.com?WT.mc_id=dotnet-55788-juyoo)
* [Visual Studio Code Extension: Bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep&WT.mc_id=dotnet-55788-juyoo)
* [PowerShell](https://docs.microsoft.com/powershell/scripting/overview?WT.mc_id=dotnet-55788-juyoo)
* [Azure CLI](https://docs.microsoft.com/cli/azure/what-is-azure-cli?WT.mc_id=dotnet-55788-juyoo)
* [Azure Storage Explorer](https://azure.microsoft.com/features/storage-explorer?WT.mc_id=dotnet-55788-juyoo)


## Getting Started ##

TBD


## Known Issues ##

### IntelliJ IDEA on Mac ###

* Starting the IntelliJ IDEA instance from command-line is strongly recommended, `idea .`; otherwise the Azure Functions Core Tools will not be properly loaded.
* Running a Java function app keeps the port 7071 even after you stop the app. It's a bug of IntelliJ IDEA. In the meantime, you should manually kill the process by running the bash script, [`kill-process.sh`](./kill-process.sh).


## Credits ##

* Icons made by [Freepik](https://www.flaticon.com/authors/freepik) from [www.flaticon.com](https://www.flaticon.com/)
