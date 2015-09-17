FROM ruby:2.2.2
MAINTAINER nick@nickpellant.com

RUN apt-get update && apt-get install -y build-essential

ENV APP_HOME /marmite
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME

RUN bundle install

ENTRYPOINT ["bundle", "exec"]
CMD ["rspec"]
