class AccfetcherJob
  include SuckerPunch::Job

  def perform
    subscribers = Subscriber.where(isNotified: false).limit(80)
    subscribers.each do |user|
      begin
        SenderMailer.email(user).deliver
        user.isNotified = true
        user.save
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        Rails.logger.info "Can not send email to " + user.email
        Rails.logger.info e.inspect
      end
    end

  end

end
