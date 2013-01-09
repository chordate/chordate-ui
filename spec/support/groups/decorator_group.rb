require "spec_helper"

shared_examples_for "a decorator" do
  describe "allowed attributes" do
    it "allows attributes" do
      decorator_name = subject.class.name.underscore.split('_').map(&:capitalize).join(' ')

      unless respond_to?(:allowed)
        raise MockExpectationError.new(<<-ERROR)
The #{decorator_name} needs to define a set of allowed attributes.

                      describe MyDecorator do
                        let(:allowed) { [:name, :admin] }

                        it_behaves_like "a decorator"
                      end
        ERROR
      end

      allowed_keys = subject.class.allowed

      allowed.each do |attr|
        unless allowed_keys.include?(attr.to_s)
          raise MockExpectationError.new(<<-ERROR)
The #{decorator_name} should allow the '#{attr}' attribute,
                      but only allows #{allowed_keys}.

                      class MyDecorator
                        include Decorator
                        allow :#{attr}, ...
                      end
          ERROR
        end
      end
    end
  end
end
