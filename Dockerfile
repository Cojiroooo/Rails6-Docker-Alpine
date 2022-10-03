FROM ruby:2.7.1-alpine3.11

ENV ROOT="/app"
ENV LANG=C.UTF-8

WORKDIR ${ROOT}

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        gcc \
        g++ \
        libc-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        make \
        less \
        nodejs \
        postgresql \
        postgresql-dev \
        tzdata \
        yaml-dev \
        yarn && \
    apk add --virtual build-packages --no-cache \
        build-base \
        curl-dev

COPY Gemfile ${ROOT}
# COPY Gemfile.lock ${ROOT}

RUN bundle install
RUN apk del build-packages

COPY . ${ROOT}

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]