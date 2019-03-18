#!/usr/bin/env bash
tcaVersion=$(grep -Po 'jetbrains/teamcity-agent:\K[^\r\n]+' Dockerfile)
printf "##teamcity[setParameter name='tca.version' value='%s']\n" ${tcaVersion}
