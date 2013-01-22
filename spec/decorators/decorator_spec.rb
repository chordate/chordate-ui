require "spec_helper"

describe Decorator do
  class BaseDecorator
    include Decorator
  end

  describe ".new" do
    it "should take one argument" do
      expect {
        BaseDecorator.new("thing")
      }.not_to raise_error
    end

    describe "the item passed to new" do
      class OtherDecorator
        include Decorator
      end

      it "should expose the item as the class name" do
        BaseDecorator.new("other").respond_to?(:base).should == true
        OtherDecorator.new("base").respond_to?(:other).should == true
      end

      it "should return the passed in items" do
        BaseDecorator.new("other").base.should == "other"
        OtherDecorator.new(1_000).other.should == 1_000
      end
    end
  end

  describe ".many" do
    let(:items) { 2.times.collect {|i| mock("item", :attributes => {:id => i}) } }

    subject { BaseDecorator.many(items) }

    it "should return an array of decorators" do
      subject.collect(&:class).uniq.should == [BaseDecorator]
    end

    it "should be the decorator of the passed items" do
      subject.to_json.should == [
        BaseDecorator.new(items.first),
        BaseDecorator.new(items.last)
      ].to_json
    end
  end

  describe "#as_json" do
    before do
      @item = mock("item", :attributes => {'id' => 10, 'created_at' => 33, 'updated_at' => 44, 'other' => :value, 'string' => 'keys', 'thing' => 2})
    end

    it "should be the attributes" do
      json = BaseDecorator.new(@item).as_json

      json.should == {
        'id' => 10,
        'created_at' => 33,
        'updated_at' => 44
      }
    end

    describe "when adding allowed attributes" do
      class RestrictedDecorator
        include Decorator
        allow :other, :thing
      end

      subject { RestrictedDecorator.new(@item) }
      let(:allowed) { [:other, :thing] }

      it "should restrict the attributes" do
        json = subject.as_json

        json.should == {
            'id' => 10,
            'created_at' => 33,
            'updated_at' => 44,
            'other' => :value,
            'thing' => 2
        }
      end

      it_behaves_like "a decorator"
    end
  end
end
