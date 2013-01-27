ENV["RAILS_ENV"] ||= 'test'

require_relative "../lib/require"

require_all File.expand_path("../../config/environment", __FILE__),
            'rspec/rails', 'rspec/autorun', 'rspec/expectations', 'capybara/rspec',
            'capybara/poltergeist', 'webmock/rspec', 'selenium/webdriver'

require_all *Dir[Rails.root.join("spec/support/**/*.rb")]

Rails.logger.info "\n[#{Time.now.utc}] - Logging with level ERROR (4). see #{__FILE__}:#{__LINE__}"
Rails.logger.level = 4

silence_warnings do
  Redis = MockRedis
end

load Rails.root.join("db", "seeds.rb")
Hat.redis {|r| r.flushdb }

Capybara.javascript_driver = (%w(t true y yes).include?(ENV['POLTERGEIST']) ? :poltergeist : :selenium)

RSpec.configure do |config|
  config.mock_with :rspec

  config.order = "rand:605"

  config.formatter = :nested if ENV['NESTED_RSPEC'] == 1
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false

  config.include ControllerHelper, :type => :controller
  config.include RequestHelper, :type => :request

  config.before(:all) do
    WebMock.disable_net_connect!(:allow_localhost => true)
  end

  config.after(:each) do
    Hat.redis {|r| r.flushdb }
    Timecop.return
  end

  config.after(:all) do
    WebMock.allow_net_connect!
  end
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection ||= ConnectionPool::Wrapper.new(:size => 1) { retrieve_connection }
  end
end

ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

class MockExpectationError < Exception; end
