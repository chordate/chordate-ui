require "spec_helper"

describe :transact do
  before do
    @foo = mock("foo", :bar => nil, :baz => nil)
    @block = -> { @foo.bar; @foo.baz }
  end

  it "should call the block" do
    @foo.should_receive(:bar)

    transact(&@block)
  end

  it "should wrap the block in a transaction" do
    ActiveRecord::Base.should_receive(:transaction).and_yield do
      @foo.should_receive(:bar).ordered
      @foo.should_receive(:baz).ordered
    end

    transact(&@block)
  end

  it "should return the last item" do
    @foo.stub(:baz).and_return("A VALUE")

    transact(&@block).should == "A VALUE"
  end

  describe "when no block is given" do
    it "should not error" do
      expect {
        transact
      }.not_to raise_error
    end
  end
end
