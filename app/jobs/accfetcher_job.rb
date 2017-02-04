class AccfetcherJob
  include SuckerPunch::Job

  def perform
    subscribers = Subscriber.where(isNotified:[nil, false]).limit(80)
    subscribers.each do |user|
      user.isNotified = true
      user.save
      SenderMailer.email(user.email).deliver
    end
  end
end
