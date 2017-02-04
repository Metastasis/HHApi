class HeadhunterController < ApplicationController
  require 'oauth2'

  def index
    client_id = 'IMAVQSTQVJKJOHPILL7C5PQV0S22PACA6AJGGHAH7HCOQGLEN94027GFO46737GD'
    client_secret = 'NQA3UQQFK1F4U2M27RNBVSBF9F9QDQJTKJBD3DARTMCTJD2G9OH6TV908NCO3PN7'
    site = 'https://hh.ru/oauth/authorize'
    redirect = 'https://glacial-island-93830.herokuapp.com'

    @client = OAuth2::Client.new(client_id, client_secret, :site => site)
    @client.auth_code.authorize_url(:redirect_uri => redirect)
    @token = client.auth_code.get_token('authorization_code_value')

  end
end
