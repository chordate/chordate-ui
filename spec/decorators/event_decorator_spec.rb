require "spec_helper"

describe EventDecorator do
  let(:event) { FactoryGirl.build(:event) }
  let(:allowed) { [:generated_at, :env, :klass, :source, :message, :model_type, :model_id, :task] }

  subject { EventDecorator.new(event) }

  it_behaves_like "a decorator"
end
