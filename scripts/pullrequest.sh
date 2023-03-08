#!/bin/bash

script_loading () {
  source scripts/list.sh
}

script_pr () {
  # cargando scripts adicionales
  script_loading

  # generando lista de repositorios
  script_list

}

"$@"