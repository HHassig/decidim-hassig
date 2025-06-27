# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "0.30.1"
gem "decidim", DECIDIM_VERSION
# gem "decidim-ai", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
# gem "decidim-design", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-superspaces", git: "https://github.com/Platoniq/decidim-superspace", branch: "deps/decidim-0.30"
# gem "decidim-templates", DECIDIM_VERSION

gem "bootsnap", "~> 1.3"

gem "puma", ">= 6.3.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman", "~> 7.0"
  gem "decidim-dev", DECIDIM_VERSION
  gem "net-imap", "~> 0.5.0"
  gem "net-pop", "~> 0.1.1"
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "web-console", "~> 4.2"
end

group :production do
end
