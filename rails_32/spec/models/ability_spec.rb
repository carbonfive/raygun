require 'spec_helper'
require 'cancan/matchers'

describe "User" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:other) { build(:user) { |u| u.id = 2 } }

  context "when working with User" do
    context "as a non-admin" do
      let(:user) { build(:user) { |u| u.id = 1 } }

      context "operating on themselves" do
        it { should     be_able_to(:read, user) }
        it { should     be_able_to(:update, user) }
        it { should_not be_able_to(:destroy, user) }
      end

      context "operating on someone else" do
        it { should_not be_able_to(:manage, other) }
        it { should_not be_able_to(:create, User) }
      end
    end

    context "as an admin" do
      let(:user) { build(:admin) { |u| u.id = 1 } }

      context "operating on themselves" do
        it { should     be_able_to(:manage, user) }
        it { should_not be_able_to(:destroy, user) }
      end

      context "operating on someone else" do
        it { should be_able_to(:manage, other) }
      end
    end
  end
end
