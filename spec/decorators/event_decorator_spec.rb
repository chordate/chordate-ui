require "spec_helper"

describe EventDecorator do
  let(:event) { FactoryGirl.build(:event) }
  let(:allowed) { [:generated_at, :env, :klass, :message, :model_type, :model_id, :action] }

  subject { EventDecorator.new(event) }

  it_behaves_like "a decorator"
end
