# Set the ruby ​​version
FROM ruby:3.2.2

# Install the necessary libraries
RUN apt-get update -qq && apt-get install -y postgresql-client

# BUNDLE_FROZEN setting
RUN bundle config --global frozen 1

# Set working directory
WORKDIR /reservations_api

# Copy and install the project gems
COPY Gemfile /reservations_api/Gemfile
COPY Gemfile.lock /reservations_api/Gemfile.lock
RUN bundle install

# Run entrypoint.sh to delete server.pid
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Listen on this specified network port
EXPOSE 3000

# Run rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
