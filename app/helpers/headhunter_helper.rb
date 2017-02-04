module HeadhunterHelper

  def getHHUrls(url, options = {})
    url = URI(url)
    fromPage = options[:fromPage] || 0
    toPage = options[:toPage] || 10

    urls = []
    for page in fromPage..toPage
      query = Rack::Utils.parse_query url.query
      query['page'] = page

      url.query = Rack::Utils.build_query query
      urls.push(URI(url.to_s))
    end

    return urls
  end

  def getResumeHtml(resumes_url, options = {})
    docs = []
    urls = getHHUrls(resumes_url, options)
    uri = urls[0]

    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

      urls.each do |url|
        uri = "#{url.path}?#{url.query}"
        request = Net::HTTP::Get.new uri

        response = http.request request
        html = response.body

        doc = Nokogiri::HTML(html) {|config| config.recover.default_html}
        docs.push(doc)
      end

    end

    return docs
  end

  def getUserInfo(docs)
    users = []
    docs.each do |doc|
      doc.css('a.output__name').each do |link|
        resume_id = link['href'].split('/')[2]
        resume_id = resume_id[/[^\?]+/]
        users.push(resume_id: resume_id)
      end
    end

    return users
  end

  def populateUsers(token, users)
    ua = "Sender/1.0 (filimonov@stforex.com)"

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
          phone = contact['value']['formatted']
        end

        if contact['type']['id'] == 'email'
          email = contact['value']
        end
      end

      users.push(firstname:firstname, lastname:lastname, email:email, phone:phone, isNotified: false)

      puts "Creating users..."
      Subscriber.where(users.last).first_or_create(users.last)
    end

    return users
  end

  def valid_url?(uri)
    uri = URI.parse(uri)
    uri && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  rescue NoMethodError
    false
  end

  def oauthOptions
    options = {
      :client_id => 'IMAVQSTQVJKJOHPILL7C5PQV0S22PACA6AJGGHAH7HCOQGLEN94027GFO46737GD',
      :client_secret => 'NQA3UQQFK1F4U2M27RNBVSBF9F9QDQJTKJBD3DARTMCTJD2G9OH6TV908NCO3PN7',
      :site => 'https://hh.ru',
      :api_site => 'https://api.hh.ru'
      # :redirect => 'https://glacial-island-93830.herokuapp.com'
    }

    return options
  end

end
