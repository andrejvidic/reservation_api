
FROM ruby:3.2.2-alpine3.18 as builder

ARG BUNDLE_GEMFILE
ARG USER
ARG USER_ID
ARG GROUP_ID
ARG GROUP_NAME

ENV BUNDLE_GEMFILE=$BUNDLE_GEMFILE
ENV USER=${USER}
ENV USER_ID=${USER_ID}
ENV GROUP_ID=${GROUP_ID}
ENV GROUP_NAME=${GROUP_NAME}

#############################
####  OS Configuration  #####
#############################
RUN addgroup -g $GROUP_ID -S $GROUP_NAME
RUN adduser -u $USER_ID -G $GROUP_NAME -s /bin/sh -D $USER
RUN mkdir /srv/reservation_api
RUN apk --update add --no-cache --virtual run-dependencies \
    bash gcc git make cmake build-base linux-headers \
    libxml2 libxml2-dev libxml2-utils libxslt libxslt-dev postgresql-dev gmp-dev

#############################
#########   Envs   ##########
#############################
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=1

#############################
##########   FS   ###########
#############################
WORKDIR /srv/reservation_api

# Copy Gemfile to build/cache gems out
COPY --chown=$USER:$GROUP_NAME Gemfile* /srv/reservation_api/

######################
####  Build gems  ####
######################
RUN bundle check || bundle install --jobs 4 --retry 3

#############################
##  application Container  ##
#############################
FROM ruby:3.2.2-alpine3.18 as app

ARG BUNDLE_GEMFILE
ARG USER
ARG USER_ID
ARG GROUP_ID
ARG GROUP_NAME

ENV BUNDLE_GEMFILE=$BUNDLE_GEMFILE
ENV USER=${USER}
ENV USER_ID=${USER_ID}
ENV GROUP_ID=${GROUP_ID}
ENV GROUP_NAME=${GROUP_NAME}


RUN addgroup -g $GROUP_ID -S $GROUP_NAME
RUN adduser -u $USER_ID -G $GROUP_NAME -s /bin/sh -D $USER
RUN  mkdir -p /srv/reservation_api
RUN apk --update add --no-cache --virtual run-dependencies \
    bash \
    build-base \
    libpq-dev \
    postgresql-client \
    postgresql-dev \
    git

USER $USER

WORKDIR /srv/reservation_api

# First, get only gems in #optimizingLayers
COPY --from=builder --chown=$USER:$GROUP_NAME /srv/reservation_api /srv/reservation_api
RUN gem install bundler && bundle install

# Then get the rest of the app code
COPY --chown=$USER:$GROUP_NAME . /srv/reservation_api

# Loads rails (generating cached bytecode via bootsnap) and exit
RUN RAILS_ENV=production bundle exec dotenv -f ".env.prod-test" bundle exec rake environment

# Otherwise db:migrate fails because this container does not have pg_dump
ENV DUMP_AFTER_MIGRATION false

#############################
##########  Run  ############
#############################
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
