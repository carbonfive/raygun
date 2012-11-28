require "spec_helper"

describe UserMailer do
  let(:user) { build_stubbed(:user) }

  describe "activation_needed_email" do
    let(:mail) { UserMailer.activation_needed_email(user) }

    it "renders the headers" do
      mail.subject.should eq("Welcome to My Awesome Site!")
      mail.to.should eq([user.email])
      mail.from.should eq(['notifications@example.com'])
    end

    it "renders the body" do
      mail.body.encoded.should match("Welcome to")
    end
  end

  describe "activation_success_email" do
    let(:mail) { UserMailer.activation_success_email(user) }

    it "renders the headers" do
      mail.subject.should eq("Your account has been activated!")
      mail.to.should eq([user.email])
      mail.from.should eq(['notifications@example.com'])
    end

    it "renders the body" do
      mail.body.encoded.should match("You have successfully activated")
    end
  end

  describe "reset_password_email" do
    let(:mail) { UserMailer.reset_password_email(user) }

    it "renders the headers" do
      mail.subject.should eq("Password reset requested")
      mail.to.should eq([user.email])
      mail.from.should eq(['notifications@example.com'])
    end

    it "renders the body" do
      mail.body.encoded.should match("You have requested to reset your password.")
    end
  end

end
