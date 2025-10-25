#!/bin/bash

function main() {
    validate_version_parameter "$@"
    echo "OWASP Dependency Check CLI Target Version = $target_version"
    verify_existing_dependency_check
    download_dependency_check
}

function validate_version_parameter() {
    target_version=$1
    if [ -z "$target_version" ]; then
        echo "USAGE: update-dependency-check.sh VERSION"
	exit 1
    fi
}

#
# Verifies if the Dependency Check CLI is already installed and if so is
# it already the target version?
#
# If so exit the script with status '0' as nothing else to do.
#
function verify_existing_dependency_check() {
    if [ -f "dependency-check/bin/dependency-check.sh" ]; then
	local command_output=$(dependency-check/bin/dependency-check.sh -v)
	if [[ "${command_output}" == *"${target_version}" ]]; then
            echo "Dependency Check CLI is already the target version"
	    exit 0
	else
            echo "Dependency Check CLI needs to be replaced due to version change"
	    echo "${command_output}"
	fi
    else
	echo "No existing Dependency Check CLI installation"
    fi
}

function download_dependency_check() {
    if [ -d "dependency-check" ]; then
	echo "Removing existing dependency-check directory"
	rm -fR dependency-check
    fi
    if curl -L "https://github.com/dependency-check/DependencyCheck/releases/download/v$target_version/dependency-check-$target_version-release.zip" \
        -o dependency-check.zip > download.log 2>&1 ; then
        echo "Dependency Check CLI Downloaded"
    else
	echo "Failed To Download Dependency Check CLI"
	exit 1
    fi
    if unzip dependency-check.zip > unzip.log 2>&1 ; then
	echo "Unzipped Dependency Check CLI"
        touch dependency-check.stale
    else
	echo "Failed to unzip Dependency Check CLI"
	exit 1
    fi
}

main "$@"
