source "https://rubygems.org"

gemspec

gem 'neography', :git => 'https://github.com/pwaleczek/neography.git', :branch => 'master'
gem 'neo4j-cypher', '~> 1.0.3'

group :development, :test do
  gem "rake",  ">= 0.8.7"
  gem 'guard-rspec'
end


group :test do
  gem "rspec", ">= 2.0"
  gem "codeclimate-test-reporter", require: nil
end
