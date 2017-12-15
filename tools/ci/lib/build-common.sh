#!/usr/bin/env bash

declare -r WORKSPACE=${WORKSPACE:-$(pwd)}
declare -r MVN_BIN="/opt/tools/maven/apache-maven-3.2.1/bin/mvn"
declare -r MVN_PREFIX="${MVN_BIN} --batch-mode --define maven.repo.local=${WORKSPACE}/.repository"
declare -r GIT_REMOTE="origin"
declare -r GIT_BIN="$(which git)"

function banner() {
  local -r title=$1
  echo
  echo "###########################"
  echo "# ${title}"
  echo "###########################"
  echo
}

function git_clean_workspace() {
  git clean --force -d -x
}

function git_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

#version based on commit count since last update to VERSION file
function jive_version() {
  local base_version=$(cat VERSION)
  if [ -z "$base_version" ]
  then
     base_version=0.0.1
  fi

  local last_commitish=$(git log --diff-filter=AM VERSION | head -1)
  if [ -z "$last_commitish" ]
  then
     echo "VERSION file not found in git"
     exit 1
  else
     tokens=($last_commitish)
     last_commitish=${tokens[1]}
  fi

  commit_count=$(git rev-list $last_commitish..HEAD | wc -w)
  head_short_sha=$(git rev-parse --short HEAD)
  printf "%s-%s-g%s\n" $base_version $commit_count $head_short_sha
}

source tools/ci/lib/build-defaults
