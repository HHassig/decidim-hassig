FROM ruby:3.3.4-slim
ARG SECRET_KEY_BASE
ARG RAILS_MASTER_KEY
ENV DEBIAN_FRONTEND=noninteractive \
    RAILS_ENV=production \
    BUNDLE_WITHOUT=development:test \
    BUNDLE_DEPLOYMENT=true \
    BUNDLE_PATH=/usr/local/bundle \
    SECRET_KEY_BASE=$SECRET_KEY_BASE \
    RAILS_MASTER_KEY=$RAILS_MASTER_KEY
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    zlib1g-dev \
    p7zip \
    libpq-dev \
    libicu-dev \
    imagemagick \
    wkhtmltopdf \
    pkg-config \
    postgresql-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y nodejs && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn
WORKDIR /app
COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install --without development test
COPY package.json /app
COPY yarn.lock /app
RUN yarn cache clean
RUN yarn install --frozen-lockfile --network-timeout 600000
RUN yarn install --frozen-lockfile
COPY . /app
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN RAILS_ENV=production NODE_ENV=production ./bin/shakapacker
RUN RAILS_ENV=production DATABASE_URL="postgresql://user:pass@127.0.0.1:5432/non_existent_db" \
    DISABLE_DATABASE_ENVIRONMENT_CHECK=1 SECRET_KEY_BASE=build \
    RAILS_MASTER_KEY=$RAILS_MASTER_KEY \
    bundle exec rake assets:precompile --trace || true
RUN rm -rf node_modules tmp/cache && \
    apt-get autoremove -y && apt-get clean
EXPOSE 3000
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
HEALTHCHECK --interval=5s --timeout=120s --start-period=30s \
  CMD curl -f http://localhost:3000/kamal-health || exit 1
CMD ["bin/rails", "server", "-b", "0.0.0.0"]