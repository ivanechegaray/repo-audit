#!/bin/bash

GITHUB_ORGS="nttdata-masterclass"

script_list () {
  # generando data emptypage
  emptypage='[

]'
  
  # generando loop por pagina
  page=0
  while true
  do
    page=$((page + 1))

    # consultando lista por pagina
    result=$(curl -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" "https://api.github.com/orgs/${GITHUB_ORGS}/repos?per_page=100&page=${page}")

    # detener proceso en caso de data emptypage
    [ "$result" = "$emptypage" ] && break

    # guardando resultados
    echo "$result" > repos_${page}.json
  done
}

"$@"