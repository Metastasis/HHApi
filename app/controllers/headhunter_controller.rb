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
    end

    if session['current_token']
      @client.site=api_site

      token = OAuth2::AccessToken.from_hash(@client, session['current_token'])
      if token.expired?
        token = token.refresh!
      end

      @r = token.get('/me', :headers => { 'User-Agent' => ua }).parsed

      @users = populateUsers(token)
      @user = []
      @user.push(email: 'neuroaugmentations@gmail.com', name: 'Non Darek')
      SenderMailer.email(@user).deliver
    end
  end

  def getResumeHtml()
    url = 'https://hh.ru/search/resume?age_to=30&order_by=publication_time&specialization=17&schedule=fullDay&text=Teletrade&area=1&pos=full_text&label=only_with_age&exp_period=all_time&logic=normal&age_from=20&saved_search_id=1846440&employment=full&isAutosearch=true'
    html = open(url)
    # html = open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})
    doc = Nokogiri::HTML(html)

    return doc
  end

  def getUserInfo(doc)
    users = []
    doc.css('a.output__name').each do |link|
      resume_id = link['href'].split('/')[2]
      resume_id = resume_id[/[^\?]+/]
      users.push(link: link['href'], resume_id: resume_id)
    end

    return users
  end

  def populateUsers(token)
    ua = "Sender/1.0 (filimonov@stforex.com)"
    doc = getResumeHtml()
    users = getUserInfo(doc)

    result = []
    users.each do |user|
      resume_url = '/resumes/' + user[:resume_id].to_s
      response = token.get(resume_url, :headers => { 'User-Agent' => ua }).parsed
      result.push(response)
    end

    users = []
    result.each do |response|
      firstname = response['first_name']
      lastname = response['last_name']
      phone = ''
      email = ''

      response['contact'].each do |contact|
        if contact['type']['id'] == 'cell'
          phone = contact['value']
        end

        if contact['type']['id'] == 'email'
          email = contact['value']
        end
      end

      users.push(firstname:firstname, lastname:lastname, email:email, phone:phone)
    end

    return users
  end

end
