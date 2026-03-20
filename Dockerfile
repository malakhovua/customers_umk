FROM cimg/ruby:2.6.5-node
USER root

ENV APP_HOME=/customers_umk
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN apt-get update && apt-get install -y libpq-dev cron nodejs

RUN gem install bundler -v 2.1.2

ENV BUNDLE_PATH=/usr/local/bundle

COPY Gemfile* ./
RUN bundle install

COPY . ./

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]