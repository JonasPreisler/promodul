class InfoMailer < ApplicationMailer

  def new_client(params)
    @email = params[:email]
    @phone = params[:phone]

    mail to: "anzorurdia@gmail.com", subject: "New client request"
  end
end
