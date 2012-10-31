require 'spec_helper'
require 'cancan/matchers'

describe "User" do
  let(:user) { create(:user) }
  let(:ability) { Ability.new(user) }

  subject { ability }

  context "when working with User" do
    context "as a non-admin" do
      context "operating on themselves" do
        it { should be_able_to(:manage, user) }
      end

      context "operating on someone else" do
        let(:other) { create(:user) }

        it { should_not be_able_to(:manage, other) }
      end
    end

    context "as an admin" do
      let(:user) { create(:admin) }
      let(:ability) { Ability.new(user) }
      let(:other) { create(:user) }

      it { should be_able_to(:manage, other) }
    end
  end
end
