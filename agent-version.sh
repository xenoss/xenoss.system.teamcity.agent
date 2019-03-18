#!/usr/bin/env bash
tcaVersion=$(grep -Po 'jetbrains/teamcity-agent:\K[^\r\n]+' Dockerfile)
printf "##teamcity[buildNumber '%s']\n" ${tcaVersion}
