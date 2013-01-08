require "spec_helper"

describe UserMailer do
  let(:user) { build_stubbed(:user, activation_state: 'pending', activation_token: 'ABC', reset_password_token: 'XYZ') }

  describe "#activation_needed_email" do
    let(:mail) { UserMailer.activation_needed_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq "Welcome to My Awesome Site!"
      expect(mail.to).to      eq [user.email]
      expect(mail.from).to    eq %w(notifications@example.com)
    end

    it "renders the body" do
      expect(mail.body.encoded).to match "Welcome to"
    end
  end

  describe "#activation_success_email" do
    let(:mail) { UserMailer.activation_success_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq "Your account has been activated!"
      expect(mail.to).to      eq [user.email]
      expect(mail.from).to    eq %w(notifications@example.com)
    end

    it "renders the body" do
      expect(mail.body.encoded).to match "You have successfully activated"
    end
  end

  describe "#reset_password_email" do
    let(:mail) { UserMailer.reset_password_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq "Password reset requested"
      expect(mail.to).to      eq [user.email]
      expect(mail.from).to    eq %w(notifications@example.com)
    end

    it "renders the body" do
      expect(mail.body.encoded).to match "Someone requested to reset your password."
    end
  end

end
