ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'rspec/expectations'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'webmock/rspec'
require 'selenium/webdriver'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Rails.logger.info "\n[#{Time.now.utc}] - Logging with level ERROR (4). see #{__FILE__}:#{__LINE__}"
Rails.logger.level = 4

silence_warnings do
  Redis = MockRedis
end

load Rails.root.join("db", "seeds.rb")

Capybara.javascript_driver = :selenium

RSpec.configure do |config|
  config.mock_with :rspec

  config.formatter = :nested if ENV['NESTED_RSPEC'] == 1
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false

  config.include ControllerHelper, :type => :controller

  config.before(:suite) do
    #DatabaseCleaner.strategy = :transaction
    #DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    #if example.metadata[:js] || example.metadata[:commit]
    #  DatabaseCleaner.strategy = :truncation
    #else
    #  DatabaseCleaner.start
    #end

    WebMock.disable_net_connect!(:allow_localhost => true)
  end

  config.after(:each) do
    WebMock.allow_net_connect!
    Timecop.return

    #DatabaseCleaner.clean
    #if example.metadata[:js] || example.metadata[:commit]
    #  DatabaseCleaner.strategy = :transaction
    #end
  end
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || ConnectionPool::Wrapper.new(:size => 1) { retrieve_connection }
  end
end

ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

class MockExpectationError < Exception; end
