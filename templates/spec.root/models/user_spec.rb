require 'spec_helper'

describe User do
  describe "validations" do
    describe "name" do
      it "is required"
    end

    describe "email" do
      it "is required"
      it "must be properly formatted"
      it "must be unique"
    end
  end
end
