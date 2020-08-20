#!/usr/bin/env bash

source .token
source /Users/denis/Documents/pyqgis/.token

echo ${GH_TOKEN}


git clone https://${GH_TOKEN}@github.com/qgis/pyqgis.git --depth 1 --branch master
cd pyqgis
git config user.email "qgisninja@gmail.com"
git config user.name "Geo-Ninja"
gsed -i 's/Sphinx project to build python API documentation for QGIS/Sphinx project to build python API documentation for QGIS./' README.md
git add README.md
git commit -m "test"
git push

exit 0

TRAVIS_BRANCH="release-3_14"

body='{
  "ref": "master",
  "inputs": {"qgis_branch": "__QGIS_VERSION_BRANCH__"}
}'
body=$(sed "s/__QGIS_VERSION_BRANCH__/${TRAVIS_BRANCH}/;" <<< $body)
curl -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token ${GH_TOKEN}" \
  https://api.github.com/repos/qgis/pyqgis/actions/workflows/2246440/dispatches \
  -d "${body}"
