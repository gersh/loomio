#
# Warning: this image is designed to be used with docker-compose as
# instructed athttps://github.com/loomio/loomio-deploy
#
# It is not a standalone image.
#
FROM ruby:2.5.3
ENV REFRESHED_AT 2018-07-17
EXPOSE 3000

# disable loomio_onboarding plugin
RUN gem update --system
RUN apt-get update -qq && apt-get install -y build-essential sudo apt-utils

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for node
# RUN apt-get install -y python python-dev python-pip python-virtualenv

# install node
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs


# switch to appuser
RUN groupadd -g 999 appuser && useradd -r -u 999 -g appuser appuser
USER appuser

ENV DISABLED_PLUGINS loomio_onboarding

# RUN mkdir /loomio
WORKDIR /loomio
ADD . /loomio
COPY config/database.docker.yml /loomio/config/database.yml
RUN bundle install

WORKDIR /loomio/client
RUN npm install
RUN npm rebuild node-sass
WORKDIR /loomio

# source the config file and run puma when the container starts
CMD /loomio/docker_start.sh
