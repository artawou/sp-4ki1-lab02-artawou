#!/usr/bin/env bash
# ЗГЕНЕРОВАНО з content/sp/environment/lab02.yml (поле verify) — E11-9, ADR 022.
#
# Перевірка середовища: кожна команда зі списку `verify` запускається і або проходить,
# або називає себе. Ненульовий код — середовище не готове.
set -u

failed=0
total=0

check() {
  total=$((total + 1))
  printf '→ %s\n' "$1"
  if bash -c "$1" >/dev/null 2>&1; then
    printf '  ок\n'
  else
    printf '  ПОМИЛКА\n'
    failed=$((failed + 1))
  fi
}

check 'docker version'
check 'docker buildx version'
check 'docker run --rm debian:12-slim true'
check 'docker history --help'
check 'git --version'

if [ "$failed" -ne 0 ]; then
  printf '\nсередовище не готове: %s з %s перевірок не пройдено\n' "$failed" "$total"
  exit 1
fi
printf '\nсередовище готове: %s з %s перевірок пройдено\n' "$total" "$total"
