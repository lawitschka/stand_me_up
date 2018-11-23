FROM ruby:2.5

# Install dependencies
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update -qq && \
    apt-get install -y -qq \
      libpq-dev nodejs vim

# Create app directory
ENV APP_HOME /usr/src/app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Copy Gemfile
ADD Gemfile* $APP_HOME/

# Set Bundler cache directory outside of app scope
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_PATH=/bundle

# Install gems
RUN bundle install --jobs 4 --quiet

# Copy working directory
ADD . $APP_HOME

# Create tmp directory
RUN mkdir $APP_HOME/tmp && \
    mkdir $APP_HOME/tmp/pids \
    mkdir $APP_HOME/log
