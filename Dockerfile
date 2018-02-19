
# see https://docs.docker.com/docker-cloud/builds/advanced/
# using ARG in FROM requires min v17.05.0-ce
ARG QGIS_VERSION=latest

FROM  qgis/qgis:${QGIS_VERSION}
MAINTAINER Denis Rouzaud <denis.rouzaud@gmail.com>

RUN pip3 install sphinx sphinx_rtd_theme

COPY . /root/QGISPythonAPIDocumentation

WORKDIR /root/QGISPythonAPIDocumentation

CMD /root/QGISPythonAPIDocumentation/scripts/build-docs.sh
