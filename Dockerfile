FROM debian:trixie-slim

LABEL maintainer.0="dr0ther" 

RUN useradd -r bitcoin \
  && apt-get update -y \
  && apt-get install -y curl gnupg gosu libminiupnpc18 libevent-dev libzmq3-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /opt

RUN curl -o /tmp/btc.tar.gz https://web.wadehomelab.com/knots-gm.tar.gz \
  && tar -xzf /tmp/btc.tar.gz -C /opt \
  && rm /tmp/btc.tar.gz \

./install_libdb48.sh amd64
COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/bitcoin/.bitcoin"]

EXPOSE 3002 8332 8333 18332 18333 18443 18444 28332 28333 38332 38333

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]
