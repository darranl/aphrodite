#!/bin/bash

function main() {
  validate_version_parameter "$@"
  echo "Galleon Target Version = $target_version"
  echo "Current Working Dir ` pwd`"
  verify_existing_galleon
  download_dependency_check
}

function validate_version_parameter() {
  target_version=$1
  if [ -z "$target_version" ]; then
    echo "USAGE: update-galleon.sh VERSION"
    exit 1
  fi
}

#
# Verifies if the Galleon is already installed.
#
# If so exit the script with status '0' as nothing else to do.
#
function verify_existing_galleon() {
  if [ -f "galleon/bin/galleon.sh" ]; then
    echo "Galleon is already installed"
    exit 0
  else
    echo "Galleon is not already installed"
  fi
}

function download_dependency_check() {
  if curl -L "https://github.com/wildfly/galleon/releases/download/$target_version/galleon-$target_version.zip" \
      -o galleon.zip > download.log 2>&1 ; then
      echo "Galleon Downloaded"
  else
    echo "Failed To Download Galleon"
    exit 1
  fi
  if unzip galleon.zip > unzip.log 2>&1 ; then
    echo "Unzipped Galleon"
    mv galleon-$target_version galleon
  else
    echo "Failed to unzip Galleon"
    exit 1
  fi
}

main "$@"
