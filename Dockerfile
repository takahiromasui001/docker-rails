FROM ruby:2.7.2
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs default-mysql-client yarn
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
RUN yarn install --check-files
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

ARG ARG_COMPOSE_WAIT_VER=2.7.3
RUN curl -SL https://github.com/ufoscout/docker-compose-wait/releases/download/${ARG_COMPOSE_WAIT_VER}/wait -o /wait
RUN chmod +x /wait
