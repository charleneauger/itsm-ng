#!/bin/bash -e
set -e -u -x -o pipefail

LOG_FILE="./tests/files/_log/units.log"
mkdir -p $(dirname "$LOG_FILE")

ATOUM_ADDITIONNAL_OPTIONS=""
if [[ "$CODE_COVERAGE" = true ]]; then
  export COVERAGE_DIR="coverage-unit"
else
  ATOUM_ADDITIONNAL_OPTIONS="--no-code-coverage";
fi

vendor/bin/atoum \
  -p 'php -d memory_limit=512M' \
  --debug \
  --force-terminal \
  --use-dot-report \
  --bootstrap-file tests/bootstrap.php \
  --fail-if-void-methods \
  --fail-if-skipped-methods \
  $ATOUM_ADDITIONNAL_OPTIONS \
  --max-children-number 10 \
  -d tests/units | tee $LOG_FILE

unset COVERAGE_DIR
