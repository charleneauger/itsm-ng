#!/bin/bash -e

LOG_FILE="./tests/files/_log/migration.log"
mkdir -p $(dirname "$LOG_FILE")

# Reconfigure DB
bin/console itsmng:database:configure \
  --config-dir=./tests/config --ansi --no-interaction \
  --reconfigure --db-name=glpitest0723 --db-host=db --db-user=root | tee $LOG_FILE

# Execute update
## First run should do the migration.
bin/console itsmng:database:update --config-dir=./tests/config --ansi --no-interaction --allow-unstable | tee $LOG_FILE
if [[ -n $(grep "No migration needed." $LOG_FILE) ]];
  then echo "bin/console itsmng:database:update command FAILED" && exit 1;
fi
## Second run should do nothing.
bin/console itsmng:database:update --config-dir=./tests/config --ansi --no-interaction --allow-unstable | tee $LOG_FILE
if [[ -z $(grep "No migration needed." $LOG_FILE) ]];
  then echo "bin/console itsmng:database:update command FAILED" && exit 1;
fi

# Execute myisam_to_innodb migration
## First run should do the migration.
bin/console itsmng:migration:myisam_to_innodb --config-dir=./tests/config --ansi --no-interaction | tee $LOG_FILE
if [[ -n $(grep "No migration needed." $LOG_FILE) ]];
  then echo "bin/console itsmng:migration:myisam_to_innodb command FAILED" && exit 1;
fi
## Second run should do nothing.
bin/console itsmng:migration:myisam_to_innodb --config-dir=./tests/config --ansi --no-interaction | tee $LOG_FILE
if [[ -z $(grep "No migration needed." $LOG_FILE) ]];
  then echo "bin/console itsmng:migration:myisam_to_innodb command FAILED" && exit 1;
fi

# Execute timestamps migration
## First run should do the migration.
bin/console itsmng:migration:timestamps --config-dir=./tests/config --ansi --no-interaction | tee $LOG_FILE
if [[ -n $(grep "No migration needed." $LOG_FILE) ]];
  then echo "bin/console glpi:migration:timestamps command FAILED" && exit 1;
fi
## Second run should do nothing.
bin/console itsmng:migration:timestamps --config-dir=./tests/config --ansi --no-interaction | tee $LOG_FILE
if [[ -z $(grep "No migration needed." $LOG_FILE) ]];
  then echo "bin/console glpi:migration:timestamps command FAILED" && exit 1;
fi

# Test that updated DB has same schema as newly installed DB
bin/console itsmng:database:configure \
  --config-dir=./tests/config --no-interaction \
  --reconfigure --db-name=glpi --db-host=db --ansi --db-user=root | tee $LOG_FILE