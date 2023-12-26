# syntax=docker/dockerfile:1
FROM ruby:3.1.4-alpine AS builder
RUN apk update && apk add --no-cache \
      vips-dev \
      build-base \
      postgresql-dev \
      nodejs \
      npm \
      yarn \
      tzdata
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
RUN rails assets:precompile

# FROM builder AS dev
FROM builder AS dev
RUN adduser -D sitarane
USER sitarane
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

FROM ruby:3.1.4-alpine AS prod
RUN apk update && apk add --no-cache \
  postgresql-dev \
  vips-dev \
  tzdata
WORKDIR /app
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY . /app
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
