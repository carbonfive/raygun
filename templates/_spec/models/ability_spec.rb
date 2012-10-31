require 'spec_helper'
require 'cancan/matchers'

describe "User" do
  context "when working with User" do
    context "as a non-admin" do
      let(:user) { build(:user) { |u| u.id = 1 } }
      subject { Ability.new(user) }

      context "operating on themselves" do
        it { should be_able_to(:manage, user) }
      end

      context "operating on someone else" do
        let(:other) { build(:user) { |u| u.id = 2 } }

        it { should_not be_able_to(:manage, other) }
      end
    end

    context "as an admin" do
      let(:user) { build(:admin) { |u| u.id = 1 } }
      subject { Ability.new(user) }

      context "operating on themselves" do
        it { should be_able_to(:manage, user) }
      end

      context "operating on someone else" do
        let(:other) { build(:user) { |u| u.id = 2 } }

        it { should be_able_to(:manage, other) }
      end
    end
  end
end
