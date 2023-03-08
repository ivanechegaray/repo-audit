#!/bin/bash

script_loading () {
  source scripts/list.sh
}

script_clean () {
  rm -rf *.txt
  rm -rf *.json
}

script_pr () {
  # cargando scripts adicionales
  script_loading

  # generando archivo base
  echo "Repository,develop,release,staging,main" > pullrequest.xls

  # generando lista de repositorios
  script_list

  # generando loop por repositorio
  while read r
  do
    # capturando resultado por ramas    
    result_develop=$(curl -L -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${GITHUB_ORGS}/${r}/branches/develop/protection | jq .required_pull_request_reviews.required_approving_review_count)
    result_release=$(curl -L -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${GITHUB_ORGS}/${r}/branches/release/protection | jq .required_pull_request_reviews.required_approving_review_count)
    result_staging=$(curl -L -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${GITHUB_ORGS}/${r}/branches/staging/protection | jq .required_pull_request_reviews.required_approving_review_count)
    result_main=$(curl -L -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${GITHUB_ORGS}/${r}/branches/main/protection | jq .required_pull_request_reviews.required_approving_review_count)

    # procesando resultados
    if [ "${result_develop}" == "null" ]
    then
      result_develop="deactivated"
      export result_develop=${result_develop}
    else
      result_develop="active"
      export result_develop=${result_develop}
    fi

    if [ "${result_release}" == "null" ]
    then
      result_release="deactivated"
      export result_release=${result_release}
    else
      result_release="active"
      export result_release=${result_release}
    fi

    if [ "${result_staging}" == "null" ]
    then
      result_staging="deactivated"
      export result_staging=${result_staging}
    else
      result_staging="active"
      export result_staging=${result_staging}
    fi

    if [ "${result_main}" == "null" ]
    then
      result_main="deactivated"
      export result_main=${result_main}
    else
      result_main="active"
      export result_main=${result_main}
    fi

    # listando ramas activas
    curl -L -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${GITHUB_ORGS}/${r}/branches | jq -r .[].name > branches.txt

    # ramas no existentes
    DEVELOP_TATUS=$(cat branches.txt | grep develop | wc -l)    
    if [ "${DEVELOP_TATUS}" -eq 0 ]
    then
      result_develop="none"
      export result_develop=${result_develop}
    fi

    RELEASE_TATUS=$(cat branches.txt | grep release | wc -l)    
    if [ "${RELEASE_TATUS}" -eq 0 ]
    then
      result_release="none"
      export result_release=${result_release}
    fi

    STAGING_TATUS=$(cat branches.txt | grep staging | wc -l)    
    if [ "${STAGING_TATUS}" -eq 0 ]
    then
      result_staging="none"
      export result_staging=${result_staging}
    fi

    MAIN_TATUS=$(cat branches.txt | grep main | wc -l)    
    if [ "${MAIN_TATUS}" -eq 0 ]
    then
      result_main="none"
      export result_main=${result_main}
    fi

    # guardando resultados
    echo "${r},${result_develop},${result_release},${result_staging},${result_main}" >> pullrequest.xls
  done < repos.txt

  # limpiando temporales
  script_clean
}

script_checks () {
  # cargando scripts adicionales
  script_loading

  # generando archivo base
  echo "Repository,develop,release,staging,main" > checks.xls

  # generando lista de repositorios
  script_list

  # generando loop por repositorio
  while read r
  do
    # capturando resultado por ramas    
    result_develop=$(curl -L -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${GITHUB_ORGS}/${r}/branches/develop/protection | jq -r .required_status_checks)
    result_release=$(curl -L -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${GITHUB_ORGS}/${r}/branches/release/protection | jq -r .required_status_checks)
    result_staging=$(curl -L -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${GITHUB_ORGS}/${r}/branches/staging/protection | jq -r .required_status_checks)
    result_main=$(curl -L -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${GITHUB_ORGS}/${r}/branches/main/protection | jq -r .required_status_checks)

    # procesando resultados
    if [ "${result_develop}" == "null" ]
    then
      result_develop="deactivated"
      export result_develop=${result_develop}
    else
      result_develop="active"
      export result_develop=${result_develop}
    fi

    if [ "${result_release}" == "null" ]
    then
      result_release="deactivated"
      export result_release=${result_release}
    else
      result_release="active"
      export result_release=${result_release}
    fi

    if [ "${result_staging}" == "null" ]
    then
      result_staging="deactivated"
      export result_staging=${result_staging}
    else
      result_staging="active"
      export result_staging=${result_staging}
    fi

    if [ "${result_main}" == "null" ]
    then
      result_main="deactivated"
      export result_main=${result_main}
    else
      result_main="active"
      export result_main=${result_main}
    fi

    # listando ramas activas
    curl -L -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/${GITHUB_ORGS}/${r}/branches | jq -r .[].name > branches.txt

    # ramas no existentes
    DEVELOP_TATUS=$(cat branches.txt | grep develop | wc -l)    
    if [ "${DEVELOP_TATUS}" -eq 0 ]
    then
      result_develop="none"
      export result_develop=${result_develop}
    fi

    RELEASE_TATUS=$(cat branches.txt | grep release | wc -l)    
    if [ "${RELEASE_TATUS}" -eq 0 ]
    then
      result_release="none"
      export result_release=${result_release}
    fi

    STAGING_TATUS=$(cat branches.txt | grep staging | wc -l)    
    if [ "${STAGING_TATUS}" -eq 0 ]
    then
      result_staging="none"
      export result_staging=${result_staging}
    fi

    MAIN_TATUS=$(cat branches.txt | grep main | wc -l)    
    if [ "${MAIN_TATUS}" -eq 0 ]
    then
      result_main="none"
      export result_main=${result_main}
    fi

    # guardando resultados
    echo "${r},${result_develop},${result_release},${result_staging},${result_main}" >> checks.xls
  done < repos.txt

  # limpiando temporales
  script_clean
}

script_inventory () {
  # cargando scripts adicionales
  script_loading

  # generando archivo base
  echo "repoName,repoType,repoDate,repoUser,repoOwner,repoTeam" > inventory.xls

  # generando lista de repositorios
  script_list

  # generando loop por repositorio
  while read r
  do

    if [ "$(echo ${r} | cut -d"-" -f1-2)" == "matrix-function" ] || [ "$(echo ${r} | cut -d"-" -f1-2)" == "crm-function" ]
    then
      export repoType="function"

    elif [ "$(echo ${r} | cut -d"-" -f1-2)" == "matrix-script" ] || [ "$(echo ${r} | cut -d"-" -f1-2)" == "matrix-python" ]
    then
      export repoType="script"

    elif [ "$(echo ${r} | cut -d"-" -f1-2)" == "matrix-image" ]
    then
      export repoType="image"

    elif [ "$(echo ${r} | cut -d"-" -f1-3)" == "matrix-infrastructure-apigateway" ] || [ "$(echo ${r} | cut -d"-" -f1-3)" == "crm-infrastructure-apigateway" ]
    then
      export repoType="apigateway"

    elif [ "$(echo ${r} | cut -d"-" -f1-2)" == "matrix-infrastructure" ]
    then
      export repoType="infrastructure"

    elif [ "$(echo ${r} | cut -d"-" -f1-2)" == "matrix-template" ]
    then
      export repoType="template"

    elif [ "$(echo ${r} | cut -d"-" -f1-2)" == "matrix-container" ]
    then
      export repoType="container"

    elif [ "$(echo ${r} | cut -d"-" -f1-2)" == "terraform-aws" ]
    then
      export repoType="module"

    elif [ "$(echo ${r} | cut -d"-" -f1-2)" == "terraform-template" ]
    then
      export repoType="module"

    elif [ "$(echo ${r} | cut -d"-" -f1-2)" == "matrix-etl" ]
    then
      export repoType="etl"

    elif [ "$(echo ${r} | cut -d"-" -f1-3)" == "matrix-app-front" ]
    then
      export repoType="mobile"

    elif [ "$(echo ${r} | cut -d"-" -f1-2)" == "matrix-frontend" ]
    then
      export repoType="frontend"

    elif [ "$(echo ${r} | cut -d"-" -f1-2)" == "matrix-api" ]
    then
      export repoType="testing"

    else
      export repoType="nodata"
    fi

    # capturando repoOwner
    if [ "${repoType}" == "function" ] || [ "${repoType}" == "container" ] || [ "${repoType}" == "apigateway" ] || [ "${repoType}" == "etl" ] || [ "${repoType}" == "frontend" ] || [ "${repoType}" == "mobile" ]
    then
      export repoOwner="backend"

    elif [ "${repoType}" == "image" ] || [ "${repoType}" == "script" ] || [ "${repoType}" == "template" ]
    then
      export repoOwner="devops"

    elif [ "${repoType}" == "module" ] || [ "${repoType}" == "infrastructure" ]
    then
      export repoOwner="cloud"

    elif [ "${repoType}" == "testing" ]
    then
      export repoOwner="qa"

    else
      export repoOwner="nodata"
    fi

    # capturando repoTeam
    if [ "${repoType}" == "function" ] || [ "${repoType}" == "container" ] || [ "${repoType}" == "apigateway" ] || [ "${repoType}" == "etl" ] || [ "${repoType}" == "frontend" ] || [ "${repoType}" == "mobile" ]
    then
      export repoTeam="nodata"

    elif [ "${repoType}" == "image" ] || [ "${repoType}" == "script" ] || [ "${repoType}" == "template" ]
    then
      export repoTeam="cross" # devops

    elif [ "${repoType}" == "module" ] || [ "${repoType}" == "infrastructure" ]
    then
      export repoTeam="cross" # cloud

    elif [ "${repoType}" == "testing" ]
    then
      export repoTeam="cross" # cloud

    else
      export repoTeam="nodata"
    fi

    # capturando usuario de creacion
    repoUser=$(cat data/data.json | jq -r '.[] | select(.repo=="'${r}'").user')
    
    if [ "${repoUser}" == "" ]
    then
      export repoUser="nodata"
    fi

    # capturando fecha de creacion
    repoDate=$(cat data.json | jq -r '.[] | select(.name=="'${r}'").created_at' | awk -F 'T' '{print $1}')

    # guardando resultados
    echo "${r},${repoType},${repoDate},${repoUser},${repoOwner},${repoTeam}" >> inventory.xls
  done < repos.txt

  # limpiando temporales
  script_clean
}

"$@"