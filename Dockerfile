FROM ruby:alpine

RUN apk update && apk upgrade && \
    apk add --no-cache git 
RUN git clone https://github.com/rea-cruitment/simple-sinatra-app.git
WORKDIR simple-sinatra-app
RUN bundle install 
ENTRYPOINT ["bundle", "exec", "rackup", "--host", "0.0.0.0" ]
