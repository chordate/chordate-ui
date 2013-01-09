require "spec_helper"

describe ApplicationUser do
  it { should belong_to(:application) }
  it { should belong_to(:user) }
end
