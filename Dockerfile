FROM ruby:2.3.1

# Needed for rspec
RUN apt-get update && apt-get install -y nodejs

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install

WORKDIR /app

ENTRYPOINT ["bundle", "exec", "rspec", "--tag", "smoke"]
