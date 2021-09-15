class InfoMailer < ApplicationMailer

  def new_client(params)
    @email = params[:email]
    @phone = params[:phone]

    mail to: "info@promodul.no", subject: "New client request"
  end
end
