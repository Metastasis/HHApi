json.extract! subscriber, :id, :firstname, :lastname, :email, :phone, :isNotified, :id_hh, :created_at, :updated_at
json.url subscriber_url(subscriber, format: :json)