module DecoratorExampleGroup
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :model
  end

  RSpec.configure do |config|
    config.include self, :example_group => { :file_path => %r(spec/decorators) }
  end
end
