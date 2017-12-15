FROM python:2.7-alpine

# Openssl
RUN apk add --update \
  && apk add --no-cache openssl bash curl jq

# Horizon
ADD . /horizon
RUN pip install -r /horizon/requirements.txt
RUN pip install awscli
ENTRYPOINT ["/horizon/entrypoint.sh"]
