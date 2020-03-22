#!/bin/bash

set -e
export AZURE_HTTP_USER_AGENT="GITHUBACTIONS_${GITHUB_ACTION_NAME}_${GITHUB_REPOSITORY}"

if [[ -z "$resourceGroupName" ]]
then
  echo "resourceGroupName is not set." >&2
  exit 1
fi

if [[ -z "$resourceGroupCommand" ]] || [[ ${resourceGroupCommand,,} == 'create' ]]
then
  echo "Executing commands to Create/Update resource group."
  # Create Resource group if it does not exists

  resourceGroupExists=$(az group exists -n "$resourceGroupName")
  if [[ $resourceGroupExists == "false" ]]
  then
      if [[ -z "$resourceGroupLocation" ]]
      then
        echo "resourceGroupLocation is not set." >&2
        exit 1
      fi
      az group create --name "$resourceGroupName" --location "$resourceGroupLocation"
  fi

  uri_regex="^(http://|https://)\\w+"
  guid=$(uuidgen | cut -d '-' -f 1)

  # Download parameters file if it is a remote URL

  if [[ $parametersFile =~ $uri_regex ]]
  then
    PARAMETERS=$(curl "$parametersFile")
    echo "Downloaded parameters from ${parametersFile}"
  else
    paramsFile="${GITHUB_WORKSPACE}/${parametersFile}"
    if [[ ! -e "$paramsFile" ]]
    then
      echo "Parameters file ${paramsFile} does not exists." >&2
      exit 1
    fi
    PARAMETERS="@${paramsFile}"
  fi

  # Generate deployment name if not specified

  if [[ -z "$deploymentName" ]]
  then
    deploymentName="Github-Action-azdeploy-${guid}"
    echo "Generated Deployment Name ${deploymentName}"
  fi

  # Deploy ARM template

  if [[ $templateFile =~ $uri_regex ]]
  then
    az group deployment create -g "$resourceGroupName" --name "$deploymentName" --template-uri "$templateFile" --parameters "$PARAMETERS"
  else
    templFile="${GITHUB_WORKSPACE}/${templateFile}"
    if [[ ! -e "$templFile" ]]
    then
      echo "Template file ${templFile} does not exists." >&2
      exit 1
    fi
    az group deployment create -g "$resourceGroupName" --name "$deploymentName" --template-file "$templFile" --parameters "$PARAMETERS"
  fi
elif [[ ${resourceGroupCommand,,} == 'delete' ]]
then
  echo "Executing commands to Delete resource group."
  az group delete -n "$resourceGroupName" --yes
else
  echo "Invalid resourceGroupCommand. Allowed values are: CREATE, DELETE." >&2
  exit 1
fi