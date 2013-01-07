module Decorator
  extend ActiveSupport::Concern

  included do
    class_attribute :_allowed

    def initialize(item)
      @item = item
    end

    define_method :"#{name.gsub(/Decorator/, '').underscore}" do
      @item
    end

    def as_json(*)
      @item.attributes.slice(*self.class.allowed)
    end

    class << self
      def allow(*keys)
        self._allowed = self.get_allowed_keys | keys.to_a.flatten.map(&:to_s)
      end

      def allowed
        get_allowed_keys
      end

      def get_allowed_keys
        self._allowed ||= %w(id created_at updated_at)
      end
    end
  end
end
