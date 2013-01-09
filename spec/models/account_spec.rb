require "spec_helper"

describe Account do
  it { should have_many(:users) }
end
