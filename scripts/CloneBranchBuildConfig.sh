#!/usr/bin/env bash
AppCenterAuthToken=""
Branch="Master"
Owner_Name="Examples"
App_Name="Android_Xamarin"
currenDirectory=$(PWD)
saveJsonFilePath=$currenDirectory/saveJsonFilePath.json
updatedJsonFilePath=$currenDirectory/updatedJsonFilePath.json
sendme=""

#curl https://www.time.com -x http://192.168.68.64:8888

Get_Branch_Configuration()
{
    local branch=$1
    local owner_name=$2
    local app_name=$3
    local appCenterAuthToken=$4
    local removeDistributionconfig=$5
    local uri="https://api.appcenter.ms/v0.1/apps/$owner_name/$app_name/branches/$branch/config"
   
 
    #sendme=$(curl -X GET $uri -H "X-API-Token: $appCenterAuthToken" -H "Accept: application/json" -o $saveJsonFilePath)
    curl -X GET $uri -H "X-API-Token: $appCenterAuthToken" -H "Accept: application/json" -o $saveJsonFilePath
    cat $saveJsonFilePath    
   
    echo "removeDistributionconfig:"$removeDistributionconfig

    if [ -z $removeDistributionconfig ];
    then
        echo "Keeping Distribution Settings Intact"
        cat $saveJsonFilePath | jq '.'
    else
        echo "Removing Distribution Settings If Enabled"
        cat $saveJsonFilePath
        cat $saveJsonFilePath | jq 'del(.toolsets.distribution)' > $updatedJsonFilePath 
    fi
    echo "Final Results:"    
    cat $updatedJsonFilePath | jq '.'
}

Set__New_Branch_Configuration()
{
    #NOTE: If the branch you are configuring already has a configuration, use the PUT method instead of POST
    local branch=$1
    local owner_name=$2
    local app_name=$3
    local appCenterAuthToken=$4
    local uri="https://api.appcenter.ms/v0.1/apps/$owner_name/$app_name/branches/$branch/config"

    #Set the new Branch Name
    setbranchconfigFilePath=$currenDirectory/setbranchconfig.json
    cat $updatedJsonFilePath | jq '.branch.name = "'$branch'"' > $setbranchconfigFilePath
    data=$(cat $setbranchconfigFilePath)
    echo "Build Configuration for Set New Branch Operation:"
    echo $data 
    curl -H "X-API-Token: $appCenterAuthToken" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "$data" $uri
}

Set__Existing_Branch_Configuration()
{
    #NOTE: If the branch you are configuring already has a configuration, use the PUT method instead of POST
    local branch=$1
    local owner_name=$2
    local app_name=$3
    local appCenterAuthToken=$4
    local buildConfig=$5
    local uri="https://api.appcenter.ms/v0.1/apps/$owner_name/$app_name/branches/$branch/config"

    echo "Build Configuration for Set Existing Branch Operation:"
    echo $data 
    curl -H "X-API-Token: $appCenterAuthToken" -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d "$data" $uri
}

Get_Branch_Configuration $Branch $Owner_Name $App_Name $AppCenterAuthToken true

Set__New_Branch_Configuration "NewFeature" $Owner_Name $App_Name $AppCenterAuthToken

Set__Existing_Branch_Configuration "NewFeature" $Owner_Name $App_Name $AppCenterAuthToken $(cat $setbranchconfigFilePath)
