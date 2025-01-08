# Use the pre-built Ruby 3.3.0 image if available
FROM ruby:3.3.0

# Install required system dependencies
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  sqlite3 \
  build-essential

# Set the working directory inside the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile* ./ 

# Install Ruby gems (bundler)
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose port 3000 for the Rails app
EXPOSE 3000

# Start Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
