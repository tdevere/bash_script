#!/usr/bin/env bash

# Expanded Sample from https://vscode.dev/github/tdevere/AppCenterSupportDocs/blob/24d85a320e5d3e69210627a224309eb6e4eb87af/Build_Scripts/Remove_Project_From_Solution.md#L21-L97
# Handles repos with more than one sln file
echo "appcenter-post-clone script: Remove Projects from Solution"
echo "Searching for Multiple Solution Files"
SLN_PATH=$(find $APPCENTER_SOURCE_DIRECTORY -iname '*.sln' -type f -print0)    

if [ -z "$SLN_PATH" ]
then 
    echo "No Solution Found. Exiting Script."
    exit 
else
    echo "SLN_PATH = $SLN_PATH"
fi

if [ -z "$RemoveUWPProjects" ]
then 
    echo "Do Not Remove RemoveUWPProjects"
else
    echo "Searching for UWP Projects"
	UWP_PATHS=()
	while IFS=  read -r -d $'\0'; do
		UWP_PATHS+=("$REPLY")
	done < <(find $APPCENTER_SOURCE_DIRECTORY -iname '*UWP*.csproj' -print0)
	for i in "${UWP_PATHS[@]}"
	do
		echo "Removing $i from $SLN_PATH" || true
		dotnet sln $SLN_PATH remove $i || true
	done
fi

if [ -z "$RemoveANDROIDProjects" ]
then 
    echo "Do Not Remove RemoveANDROIDProjects"
else
    echo "Searching for Android Projects"
	ANDROID_PATHS=()
	while IFS=  read -r -d $'\0'; do
		ANDROID_PATHS+=("$REPLY")
	done < <(find $APPCENTER_SOURCE_DIRECTORY -iname '*Android*.csproj' -print0)
	for i in "${ANDROID_PATHS[@]}"
	do
		echo "Removing $i from $SLN_PATH" || true
		dotnet sln $SLN_PATH remove $i || true
	done
fi

if [ -z "$RemoveIOSProjects" ]
then 
    echo "RemoveIOSProjects"
else
    echo "Searching for IOS Projects"
	IOS_PATHS=()
	while IFS=  read -r -d $'\0'; do
		IOS_PATHS+=("$REPLY")
	done < <(find $APPCENTER_SOURCE_DIRECTORY -iname '*IOS*.csproj' -print0)
	for i in "${IOS_PATHS[@]}"
	do
		echo "Removing $i from $SLN_PATH" || true
		dotnet sln $SLN_PATH remove $i || true
	done
fi