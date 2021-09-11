require "rails_helper"

RSpec.describe InfoMailer, type: :mailer do
  describe "new_client" do
    let(:mail) { InfoMailer.new_client }

    it "renders the headers" do
      expect(mail.subject).to eq("New client")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
