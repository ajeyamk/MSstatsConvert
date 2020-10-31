#!/bin/bash
. $(dirname $0)/constants.sh
#Move into the test folder
cd $source_path/$code_deploy_path/$test_folder
chmod +x tests.R
./tests.R
