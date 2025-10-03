FROM ruby:3.3.1-slim

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
CMD ["ruby", "cart_example.rb"]
