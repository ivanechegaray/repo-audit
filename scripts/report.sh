#!/bin/bash

script_loading () {
  source scripts/list.sh
}

script_pr () {
  # cargando scripts adicionales
  script_loading

  # generando archivo base
  echo "Repository,develop,release,staging,main" > pullrequest.json

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
    echo "${r},${result_develop},${result_release},${result_staging},${result_main}" >> pullrequest.json
  done < repos.txt
}

script_checks () {
  # cargando scripts adicionales
  script_loading

  # generando archivo base
  echo "Repository,develop,release,staging,main" > checks.json

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
    echo "${r},${result_develop},${result_release},${result_staging},${result_main}" >> checks.json
  done < repos.txt
}

"$@"