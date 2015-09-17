FROM ruby:2.2.2
MAINTAINER nick@nickpellant.com

RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs

ENV APP_HOME /marmite_dummy
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME

RUN cd $APP_HOME; bundle install

ENTRYPOINT ["bundle", "exec"]
CMD ["rake", "-T"]
