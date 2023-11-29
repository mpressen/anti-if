# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'
gem 'minitest'
gem 'rubocop'

gem 'mutant-minitest'
source 'https://oss:igkZEHSbhvb2frpqNZXXGqVk0DvLm9gB@gem.mutant.dev' do
  gem 'mutant-license'
end
gem 'rake'

group :development do
  gem 'guard'
  gem 'guard-minitest'
end

group :test do
  gem 'simplecov', require: false
  gem 'simplecov-lcov'
end
