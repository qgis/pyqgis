
# see https://docs.docker.com/docker-cloud/builds/advanced/
# using ARG in FROM requires min v17.05.0-ce
ARG QGIS_DOCKER_TAG=latest

FROM  qgis/qgis:${QGIS_DOCKER_TAG}
MAINTAINER Denis Rouzaud <denis@opengis.ch>

RUN curl https://bootstrap.pypa.io/get-pip.py | python3
RUN pip3 install sphinx

COPY . /root/pyqgis

WORKDIR /root/pyqgis

CMD /bin/bash -c "/root/pyqgis/scripts/ci/build-and-deploy.sh ${QGIS_DOCKER_TAG}"
