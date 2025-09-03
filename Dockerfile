FROM debian:trixie-slim

LABEL maintainer.0="dr0ther" 

ENV BITCOIN_VERSION_PATCH=1
ENV BITCOIN_MAJOR_VER=28
ENV BITCOIN_DATA=/home/bitcoin/.bitcoin
ENV KNOTS_BUILD=20250305
ENV PATH=/opt/bitcoin-${BITCOIN_MAJOR_VER}.${BITCOIN_VERSION_PATCH}.knots${KNOTS_BUILD}/bin:$PATH

RUN useradd -r bitcoin \
  && apt-get update -y \
  && apt-get install -y wget gnupg gosu libminiupnpc18 libevent-dev libzmq3-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

WORKDIR /tmp/tmplibdb
RUN wget -qq "https://launchpad.net/~bitcoin/+archive/ubuntu/bitcoin/+files/libdb4.8_4.8.30-trusty1_amd64.deb" \
  && wget -qq "https://launchpad.net/~bitcoin/+archive/ubuntu/bitcoin/+files/libdb4.8-dev_4.8.30-trusty1_amd64.deb" \
  && wget -qq "https://launchpad.net/~bitcoin/+archive/ubuntu/bitcoin/+files/libdb4.8++_4.8.30-trusty1_amd64.deb" \
  && wget -qq "https://launchpad.net/~bitcoin/+archive/ubuntu/bitcoin/+files/libdb4.8++-dev_4.8.30-trusty1_amd64.deb" \
  && dpkg -i *.deb

WORKDIR /opt

COPY bitcoin-${BITCOIN_MAJOR_VER}.${BITCOIN_VERSION_PATCH}.knots${KNOTS_BUILD}/ ./

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/bitcoin/.bitcoin"]

EXPOSE 3002 8332 8333 18332 18333 18443 18444 28332 28333 38332 38333

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]
