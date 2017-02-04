class SenderMailer < ApplicationMailer
  default from: "d1mq44@gmail.com"

  def email(user)
    @user = user
    mail(to: @user.email, subject: 'Sample Email')
  end
end
