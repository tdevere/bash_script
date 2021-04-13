# AppCenter Build Script: Dynamic_Package_Name_Selection
## Instructions

### Step 1. Create an App Center environment variable named UseAppCenter and set it to "True".
![](/docs/img/appcenter_env_var.png?raw=true)

### Step 2. Add a bash script file named appcenter-pre-build.sh to the root of project (Example: ScriptTest.Android)
![](/docs/img/vs_prebuild_script_location.png?raw=true)

### Step 3. Add this code to the bash file

```
#!/usr/bin/env bash

if [ -z "$UseAppCenter" ]
then
    echo "You need define the UseAppCenter variable in App Center"
    exit
fi

echo "Using AppCenter Build Configuration: $UseAppCenter"

if [ $UseAppCenter = "True" ]; #PACKAGE NAME will become the value of the AppCenter Configuration
then
    ANDROID_MANIFEST_FILE=$PWD/Properties/AndroidManifest.xml

    if [ $APPCENTER_XAMARIN_CONFIGURATION = "Release-Test1" ];
    then
        PACKAGE_NAME=com.domain.releaseTest1
    fi

    if [ $APPCENTER_XAMARIN_CONFIGURATION = "Release-Test2" ];
    then
        PACKAGE_NAME=com.domain.releaseTest2
    fi

    echo "PACKAGE_NAME: $PACKAGE_NAME"
    echo "ANDROID_MANIFEST_FILE = $ANDROID_MANIFEST_FILE"

    if [ -e "$ANDROID_MANIFEST_FILE" ] 
    then
        echo "ANDROID_MANIFEST_FILE BEFORE COPY"
        cat $ANDROID_MANIFEST_FILE

        echo "Updating package name to $PACKAGE_NAME in AndroidManifest.xml"
        sed -i '' 's/package="[^"]*"/package="'$PACKAGE_NAME'"/' $ANDROID_MANIFEST_FILE
    
        echo "ANDROID_MANIFEST_FILE AFTER COPY"
        cat $ANDROID_MANIFEST_FILE
    fi
fi
````
