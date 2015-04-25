FROM ruby:2.2.2
MAINTAINER topper@toppingdesign.com

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app/lib/donaghy
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
COPY *.gemspec /usr/src/app/
COPY lib/donaghy/version.rb /usr/src/app/lib/donaghy/
RUN bundle install

COPY . /usr/src/app


CMD ["rspec", "spec"]
