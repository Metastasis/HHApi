class SenderMailer < ApplicationMailer
  default from: "vnfilimonov2017@gmail.com"

  def email(user)
    @user = user
    mail(to: @user.email, subject: 'Приглашение на собеседование от STForex.')
  end
end
