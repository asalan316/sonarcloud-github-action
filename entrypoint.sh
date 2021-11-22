#!/bin/bash

set -e

if [[ -z "${SONAR_TOKEN}" ]]; then
  echo "Set the SONAR_TOKEN env variable."
  exit 1
fi
# if USE_SONAR_SCANNER_CLI is set, use sonar scanner cli
if [[ -z "${USE_SONAR_SCANNER_CLI}" ]]; then
  echo "USE_SONAR_SCANNER_CLI env variable was not found... using pom.xml or build.gradle."
   if [[ -f "pom.xml" ]]; then
    echo "Maven project detected. You should run the goal 'org.sonarsource.scanner.maven:sonar' during build rather than using this GitHub Action."
    exit 1
   fi

   if [[ -f "build.gradle" ]]; then
    echo "Gradle project detected. You should use the SonarQube plugin for Gradle during build rather than using this GitHub Action."
    exit 1
   fi
fi

if [[ -z "${SONARCLOUD_URL}" ]]; then
  SONARCLOUD_URL="https://sonarcloud.io"
fi
unset JAVA_HOME
sonar-scanner -Dsonar.projectBaseDir=${INPUT_PROJECTBASEDIR} -Dsonar.host.url=${SONARCLOUD_URL} ${INPUT_ARGS}
