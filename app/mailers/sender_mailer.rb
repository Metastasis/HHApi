class SenderMailer < ApplicationMailer
  default from: "vnfilimonov2017@gmail.com"

  def email(to_email)
    mail(to: to_email, subject: 'Приглашение на собеседование от STForex.')
  end
end
