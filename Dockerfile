
# see https://docs.docker.com/docker-cloud/builds/advanced/
# using ARG in FROM requires min v17.05.0-ce
ARG QGIS_DOCKER_TAG=latest

FROM  qgis/qgis:${QGIS_DOCKER_TAG}
MAINTAINER Denis Rouzaud <denis@opengis.ch>

RUN curl https://bootstrap.pypa.io/get-pip.py | python3
RUN pip3 install sphinx sphinx-autodoc-typehints

COPY . /root/pyqgis

WORKDIR /root/pyqgis

RUN /root/pyqgis/scripts/install_rtd_version_theme.sh | egrep '^Installed.*\.egg$' | sed 's/^Installed //' > /root/pyqgis/rtd_theme_path

CMD /bin/bash -c "THEME_PATH=$(cat /root/pyqgis/rtd_theme_path) /root/pyqgis/scripts/build-docs.sh -v ${QGIS_VERSION} ${BUILD_OPTIONS}"
