require 'spec_helper'

describe User do
  describe "validating" do

    subject { build(:user) }

    describe "name" do
      specify { expect(subject).to reject_value(nil).for(:name) }
      specify { expect(subject).to reject_value('').for(:name) }
      specify { expect(subject).to accept_value('a' * 30).for(:name) }

      it "should be less than 30 characters" do
        expect(subject).to reject_value('a' * 31).for(:name)
      end
    end

    describe "email" do
      specify { expect(subject).to reject_value(nil).for(:email) }
      specify { expect(subject).to reject_value('').for(:email) }
      specify { expect(subject).to reject_value(' ').for(:email) }

      specify { expect(subject).to accept_value('a@b.com').for(:email) }
      specify { expect(subject).to accept_value('a@b.c.com').for(:email) }
      specify { expect(subject).to reject_value('a@b').for(:email) }
      specify { expect(subject).to reject_value('a.b.com').for(:email) }

      it "must be unique" do
        subject.save
        stunt_double = subject.dup
        expect(stunt_double).to reject_value(subject.email).for(:email)
      end
    end
  end
end
