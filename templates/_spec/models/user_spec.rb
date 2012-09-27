require 'spec_helper'

describe User do
  describe "validations" do

    subject { build(:user) }

    describe "name" do
      it "is required" do
        subject.should_not accept_values(:email, nil, '')
      end

      it "should be less than 30 characters"
    end

    describe "email" do
      it "is required" do
        subject.should_not accept_values(:email, nil, '', ' ')
      end

      it "must be properly formatted" do
        subject.should     accept_values(:email, 'a@b.com', 'a@b.c.com')
        subject.should_not accept_values(:email, 'a@b', 'a.b.com')
      end

      it "must be unique"
    end
  end
end
