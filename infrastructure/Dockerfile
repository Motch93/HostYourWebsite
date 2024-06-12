FROM docker.io/nginx:latest as nginx

LABEL maintainer="TestUser <testwebsite@test.com>"
ARG amplify_key
ENV DEBIAN_FRONTEND=noninteractive

# Install the NGINX Amplify Agent
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y curl certbot gnupg1 tzdata procps logrotate vim sudo lsb-release ca-certificates debian-archive-keyring \
    && curl https://nginx.org/keys/nginx_signing.key | gpg1 --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://packages.amplify.nginx.com/py3/debian/ $(lsb_release -cs) amplify-agent" > /etc/apt/sources.list.d/nginx-amplify.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y nginx-amplify-agent \
    && apt-mark hold nginx-amplify-agent \
    && apt-get remove --purge --auto-remove -y curl gnupg1 \
    && rm -f /etc/apt/sources.list.d/nginx-amplify.list \
    && rm -f /usr/share/keyrings/nginx-archive-keyring.gpg \
    && rm -rf /var/lib/apt/lists/*

ENV TZ="Europe/Berlin"

# Keep the nginx logs inside the container
RUN unlink /var/log/nginx/access.log \
    && unlink /var/log/nginx/error.log \
    && touch /var/log/nginx/access.log \
    && touch /var/log/nginx/error.log \
    && chown nginx /var/log/nginx/*log \
    && chmod 644 /var/log/nginx/*log

# Adjust permissions so agent could write log under nginx user
RUN chown nginx /var/log/amplify-agent/ /var/log/amplify-agent/agent.log

ENV API_KEY=$amplify_key
ENV AMPLIFY_IMAGENAME=Amplify_Default_HOST

RUN mkdir -p /etc/letsencrypt

ENTRYPOINT ["tail", "-f", "/dev/null"]
