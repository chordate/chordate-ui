require "spec_helper"

describe FilterKlassDecorator do
  let(:filter_klass) { ["ErrorClass", 301] }
  let(:allowed) { [] }

  subject { FilterKlassDecorator.new(filter_klass) }

  it_behaves_like "a decorator"

  describe "#as_json" do
    it "should map the attributes" do
      JSON.parse(subject.to_json).should == {
        "name" => "ErrorClass",
        "count" => 301
      }
    end
  end
end
