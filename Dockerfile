FROM java:8-jre

# BEGIN osmosis installation

RUN wget -P /tmp http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-latest.tgz && \
    mkdir /opt/osmosis && \
    tar -zxvf /tmp/osmosis-latest.tgz -C /opt/osmosis && \
    rm /tmp/osmosis-latest.tgz

ENV JAVACMD_OPTIONS -server -Xmx2G
ENV OSMOSIS_HOME /opt/osmosis
ENV PATH $PATH:$OSMOSIS_HOME/bin

# END osmosis installation

# BEGIN osm2pgsql installation

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    g++ \
    git-core \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libbz2-dev \
    libgeos++-dev \
    libgeos-dev \
    liblua5.2-dev \
    libpq-dev \
    libproj-dev \
    libprotobuf-c0-dev \
    libtool \
    libxml2-dev \
    lua5.2 \
    make \
    protobuf-c-compiler &&\
    rm -rf /var/lib/apt/lists/*

ENV HOME /root
ENV OSM2PGSQL_VERSION 0.87.1

RUN mkdir src &&\
    cd src &&\
    git clone --depth 1 --branch $OSM2PGSQL_VERSION https://github.com/openstreetmap/osm2pgsql.git &&\
    cd osm2pgsql &&\
    ./autogen.sh &&\
    ./configure &&\
    make &&\
    make install &&\
    cd /root &&\
    rm -rf src

# END osm2pgsql installation

ENTRYPOINT ["/bin/bash"]
