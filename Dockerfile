
# see https://docs.docker.com/docker-cloud/builds/advanced/
# using ARG in FROM requires min v17.05.0-ce
ARG QGIS_VERSION=latest

FROM  qgis/qgis:${QGIS_VERSION}
MAINTAINER Denis Rouzaud <denis@opengis.ch>

RUN apt-get install -y python3-pip
RUN pip3 install sphinx sphinx_rtd_theme

COPY . /root/QGISPythonAPIDocumentation

WORKDIR /root/QGISPythonAPIDocumentation

CMD bash -l -c '/root/QGISPythonAPIDocumentation/scripts/install_rtd_version_theme.sh | egrep \'^Installed.*\.egg$\' | ${GP}sed \'s/^Installed //\' >> /root/sphinx_rtd_egg_path'
CMD /root/QGISPythonAPIDocumentation/scripts/build-docs.sh -v master -t $(cat /root/sphinx_rtd_egg_path)
