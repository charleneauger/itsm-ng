#!/bin/bash -e
set -e -u -x -o pipefail

ATOUM_ADDITIONNAL_OPTIONS=""
if [[ "$CODE_COVERAGE" = true ]]; then
  export COVERAGE_DIR="coverage-unit"
else
  ATOUM_ADDITIONNAL_OPTIONS="--no-code-coverage";
fi

vendor/bin/atoum \
  -p 'php -d memory_limit=512M' \
  -p 'php -d error_reporting=E_ALL^E_DEPRECATED' \
  --debug \
  --force-terminal \
  --use-dot-report \
  --bootstrap-file tests/bootstrap.php \
  --fail-if-void-methods \
  --fail-if-skipped-methods \
  $ATOUM_ADDITIONNAL_OPTIONS \
  --max-children-number 10 \
  -d tests/units

unset COVERAGE_DIR
