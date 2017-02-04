class HeadhunterController < ApplicationController
  include HeadhunterHelper

  def index
    oauth = oauthOptions
    @client = OAuth2::Client.new(oauth[:client_id], oauth[:client_secret], :site => oauth[:site])

    if !params[:code] && !session['current_token']
      url = @client.auth_code.authorize_url()
      redirect_to url
    elsif params[:code] && !session['current_token']
      @code = params[:code]
      token = @client.auth_code.get_token(@code)
      token.client.site = oauth[:api_site]
      session['current_token'] = token.to_hash
    end

    @subscribers = Subscriber.where(isNotified: false).limit(80)
  end

  def users
    if !session['current_token'] && !params[:users]
      redirect_to action: 'index'
    end

    if !valid_url? params[:resume_url]
      render html: '<b>Url is not valid</b>'
      return
    end

    oauth = oauthOptions
    @client = OAuth2::Client.new(oauth[:client_id], oauth[:client_secret], :site => oauth[:api_site])
    token = OAuth2::AccessToken.from_hash(@client, session['current_token'])
    if token.expired?
      token = token.refresh!
    end

    resumes_url = params[:resume_url]
    fromPage = params[:fromPage].to_i
    toPage = params[:toPage].to_i
    options = {:fromPage => fromPage, :toPage => toPage}

    docs = getResumeHtml(resumes_url, options)
    @users = getUserInfo(docs)
    PopulateUsersJob.perform_async(token, @users)

    render nothing: true, status: :ok, content_type: "text/html"
  end

  def email
    AccfetcherJob.perform_async

    render nothing: true, status: :ok, content_type: "text/html"
  end

end
