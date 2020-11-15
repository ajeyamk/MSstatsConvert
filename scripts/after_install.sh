#!/bin/bash
. $(dirname $0)/constants.sh
#Move into the test folder
cd $source_path/$code_deploy_path/$test_folder
# execute infra and config files
sudo chmod +x utils/infra.R
./utils/infra.R
sudo chmod +x tests.R
yes a | ./tests.R