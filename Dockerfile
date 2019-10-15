
# see https://docs.docker.com/docker-cloud/builds/advanced/
# using ARG in FROM requires min v17.05.0-ce
ARG QGIS_DOCKER_TAG=latest

FROM  qgis/qgis:${QGIS_DOCKER_TAG}
MAINTAINER Denis Rouzaud <denis@opengis.ch>

RUN curl https://bootstrap.pypa.io/get-pip.py | python3

WORKDIR /root

RUN git clone --depth 1 https://github.com/3nids/sphinx_rtd_theme.git --branch versioning2
RUN mkdir /root/pyqgis
WORKDIR /root/sphinx_rtd_theme
RUN python3 setup.py install | egrep '^Installed.*sphinx_rtd_theme.*\.egg$' | sed 's/^Installed //' > /root/pyqgis/rtd_theme_path

COPY . /root/pyqgis

WORKDIR /root/pyqgis

CMD /bin/bash -c "THEME_PATH=$(cat /root/pyqgis/rtd_theme_path) /root/pyqgis/scripts/build-docs.sh -v ${QGIS_VERSION} ${BUILD_OPTIONS}"
