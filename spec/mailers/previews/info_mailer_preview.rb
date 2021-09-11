# Preview all emails at http://localhost:3000/rails/mailers/info_mailer
class InfoMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/info_mailer/new_client
  def new_client
    InfoMailerMailer.new_client
  end

end
