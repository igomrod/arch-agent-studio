#!/bin/bash
if [ ! -f tests/bash_unit ]; then
  echo "Downloading bash_unit..."
  curl -s https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit -o tests/bash_unit
  chmod +x tests/bash_unit
fi
