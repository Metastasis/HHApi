class HeadhunterController < ApplicationController
  require 'oauth2'

  def index
    client_id = 'IMAVQSTQVJKJOHPILL7C5PQV0S22PACA6AJGGHAH7HCOQGLEN94027GFO46737GD'
    client_secret = 'NQA3UQQFK1F4U2M27RNBVSBF9F9QDQJTKJBD3DARTMCTJD2G9OH6TV908NCO3PN7'
    site = 'https://hh.ru'
    api_site = 'https://api.hh.ru'
    # redirect = 'https://glacial-island-93830.herokuapp.com'
    ua = "Sender/1.0 (filimonov@stforex.com)"

    @client = OAuth2::Client.new(client_id, client_secret, :site => site)

    if !params[:code] && !session['current_token']
      url = @client.auth_code.authorize_url()
      redirect_to url
    elsif params[:code] && !session['current_token']
      @code = params[:code]
      token = @client.auth_code.get_token(@code)
      token.client.site = api_site
      session['current_token'] = token.to_hash
    elsif session['current_token']
      @client.site=api_site
      token = OAuth2::AccessToken.from_hash(@client, session['current_token'])
      @response = token.get('/resumes', :headers => { 'User-Agent' => ua })
    end


  end
end
