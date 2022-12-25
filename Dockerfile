FROM alpine:edge

ARG AUUID="45960ed2-715c-4986-8066-5c1bfb673fcd"
ARG CADDYIndexPage="https://github.com/rfaaaaedaqere/3DCEList/archive/refs/heads/main.zip"
ARG PORT=8080

ADD etc/Caddyfile /tmp/Caddyfile
ADD etc/config.json /tmp/config.json
ADD start.sh /start.sh

RUN apk update
RUN apk add --no-cache ca-certificates caddy wget
RUN wget -O v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
RUN unzip v2ray.zip
RUN chmod +x /v2ray
RUN rm -rf /var/cache/apk/*
RUN rm -f v2ray.zip
RUN mkdir -p /etc/caddy/ /usr/share/caddy
RUN echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt
RUN wget $CADDYIndexPage -O /usr/share/caddy/index.html
RUN unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/
RUN mv /usr/share/caddy/*/* /usr/share/caddy/
RUN cat /tmp/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" >/etc/caddy/Caddyfile
RUN cat /tmp/config.json | sed -e "s/\$AUUID/$AUUID/g" >/config.json

RUN chmod +x /start.sh

CMD /start.sh
