FROM cabanaonline/python:2.7

LABEL base.image="cabanaonline/python:2.7"
LABEL description="A STAMP container."
LABEL maintainer="Alejandro Madrigal Leiva"
LABEL maintainer.email="me@alemadlei.tech"

ARG USER=cabana
ENV HOME /home/$USER
ENV DISPLAY :0

USER root

# Installs system dependencies.
RUN set -xe; \
    \
    apt-get install -y pkg-config libfreetype6-dev libxft-dev qt4-default libxext-dev python-qt4 qt4-dev-tools python-tk

# Installs python dependencies.
RUN set -xe; \
    \
    pip install setuptools_scm==1.13.1 freetype-py==1.0.2 pypng numpy==1.9.1 && \
    pip install biom-format==2.0.1 scipy==0.15.1 matplotlib==1.5.3

# Installs sip.
RUN set -xe; \
    \
    wget https://www.riverbankcomputing.com/static/Downloads/sip/4.19.25/sip-4.19.25.tar.gz && \
    tar xf sip-4.19.25.tar.gz && \
    cd sip-4.19.25 && \
    python configure.py --sip-module PyQt4.sip && \
    make && make install && \
    cd .. && rm -rf sip*

# Installs PyQT4.
RUN set -xe; \
    \
    wget https://www.riverbankcomputing.com/static/Downloads/PyQt4/4.12.3/PyQt4_gpl_x11-4.12.3.tar.gz && \
    tar xf PyQt4_gpl_x11-4.12.3.tar.gz && \
    cd PyQt4_gpl_x11-4.12.3 && \
    python configure.py --confirm-license && \
    make && make install && \
    cd .. && rm -rf PyQt4_gpl*

# Installs STAMP.
RUN set -xe; \
    \
    pip install h5py==2.6.0 && \
    pip install STAMP

ENV QT_X11_NO_MITSHM=1

# Removes development tools.
RUN set -xe; \
    \
    cd /opt/scripts && ./uninstall.sh && \
    apt-get clean && \
    apt-get autoclean;

USER cabana

# Runs STAMP
ENTRYPOINT ["STAMP"]