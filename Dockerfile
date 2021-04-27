FROM ruby:2.7-alpine
WORKDIR /app
COPY scores.rb /app
ENTRYPOINT ["ruby", "scores.rb"]
