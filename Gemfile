ruby File.read(".ruby-version").strip

source "https://rubygems.org"

gem "rails", "5.0.2"
gem "unicorn", "~> 5.1.0"
gem "logstasher", "0.6.2"
gem "airbrake", "~> 5.4.1"
gem "addressable", "~> 2.3.7"
gem "govuk-content-schema-test-helpers", "~> 1.4"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "quiet_assets", "1.1.0"
gem "capybara", "~> 2.7"
gem "poltergeist", "~> 1.9"
group :development, :test do
  gem "pry"
  gem "simplecov-rcov", "0.2.3", require: false
  gem "simplecov", "0.11.2", require: false
  gem "govuk-lint"
  gem "factory_girl_rails", "4.7.0"
  gem "timecop"
  gem "webmock", require: false
  gem "rspec-rails", "~> 3.4"
  gem "byebug" # Comes standard with Rails
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console", "~> 2.0"
end
