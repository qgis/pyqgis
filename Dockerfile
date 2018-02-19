
# see https://docs.docker.com/docker-cloud/builds/advanced/
# using ARG in FROM requires min v17.05.0-ce
ARG QGIS_VERSION=latest

FROM  qgis/qgis:${QGIS_VERSION}
MAINTAINER Denis Rouzaud <denis.rouzaud@gmail.com>

COPY . /usr/src/QGISPythonAPIDocumentation

WORKDIR /usr/src/QGISPythonAPIDocumentation

RUN ./scripts/build-docs.sh

WORKDIR /
