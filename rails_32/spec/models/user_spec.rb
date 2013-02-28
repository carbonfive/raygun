require 'spec_helper'

describe User do
  describe "validations" do

    subject { build(:user) }

    describe "name" do
      it "is required" do
        expect(subject).to_not accept_values(:name, nil, '')
      end

      it "should be less than 30 characters" do
        expect(subject).to     accept_values(:name, 'a' * 30)
        expect(subject).to_not accept_values(:name, 'a' * 31)
      end
    end

    describe "email" do
      it "is required" do
        expect(subject).to_not accept_values(:email, nil, '', ' ')
      end

      it "must be properly formatted" do
        expect(subject).to     accept_values(:email, 'a@b.com', 'a@b.c.com')
        expect(subject).to_not accept_values(:email, 'a@b', 'a.b.com')
      end

      it "must be unique" do
        subject.save
        stunt_double = subject.dup
        expect(stunt_double).to_not accept_values(:email, subject.email)
      end
    end
  end
end
