
# see https://docs.docker.com/docker-cloud/builds/advanced/
# using ARG in FROM requires min v17.05.0-ce
ARG QGIS_DOCKER_TAG=latest

FROM  qgis/qgis:${QGIS_DOCKER_TAG}
MAINTAINER Denis Rouzaud <denis@opengis.ch>

RUN curl https://bootstrap.pypa.io/get-pip.py | python3
RUN pip3 install sphinx sphinx_rtd_theme

COPY . /root/QGISPythonAPIDocumentation

WORKDIR /root/QGISPythonAPIDocumentation

CMD /root/QGISPythonAPIDocumentation/scripts/build-docs.sh -v master -t $(/root/QGISPythonAPIDocumentation/scripts/install_rtd_version_theme.sh | egrep '^Installed.*\.egg$' | ${GP}sed 's/^Installed //')
