module B2
  require 'json'
  require 'net/http'
  require 'digest/sha1'
  require_relative 'keys' # My personal account keys are stored in another file as $account_id and $application_key. Define your own in this module or a linked file.

  def self.authorize_account
    uri = URI("https://api.backblazeb2.com/b2api/v1/b2_authorize_account")
    req = Net::HTTP::Get.new(uri)
    req.basic_auth($account_id, $application_key)
    http = Net::HTTP.new(req.uri.host, req.uri.port)
    http.use_ssl = true
    res = http.start {|http| http.request(req)}
    case res
    when Net::HTTPSuccess then
        @json = res.body
    when Net::HTTPRedirection then
        fetch(res['location'], limit - 1)
    else
        res.error!
    end
  end

  def self.store_account_urls
    $api_url = @json.match(/(?<="apiUrl": ").+(?=")/).to_s
    $account_token = @json.match(/(?<="authorizationToken": ").+(?=")/).to_s
    $download_url = @json.match(/(?<="downloadUrl": ").+(?=")/).to_s
  end

  def self.get_upload_url
    bucket_id = "" # The ID of the bucket you want to upload your file to
    uri = URI("#{$api_url}/b2api/v1/b2_get_upload_url")
    req = Net::HTTP::Post.new(uri)
    req.add_field("Authorization","#{$account_token}")
    req.body = "{\"bucketId\":\"#{bucket_id}\"}"
    http = Net::HTTP.new(req.uri.host, req.uri.port)
    http.use_ssl = true
    res = http.start {|http| http.request(req)}
    case res
    when Net::HTTPSuccess then
        @json = res.body
    when Net::HTTPRedirection then
        fetch(res['location'], limit - 1)
    else
        res.error!
    end
  end

  def self.store_upload_url
    $upload_url = @json.match(/(?<="uploadUrl": ").+(?=")/).to_s
    $upload_token = @json.match(/(?<="authorizationToken": ").+(?=")/).to_s
  end

  def self.upload_file
    upload_url = "" # Provided by b2_get_upload_url
    local_file = "" # File to be uploaded
    upload_authorization_token = "" # Provided by b2_get_upload_url
    file_name = "" # The name of the file you are uploading
    content_type = ""  # The content type of the file
    sha1 = "" # SHA1 of the file you are uploading
    uri = URI(upload_url)
    req = Net::HTTP::Post.new(uri)
    req.add_field("Authorization","#{upload_authorization_token}")
    req.add_field("X-Bz-File-Name","#{file_name}")
    req.add_field("Content-Type","#{content_type}")
    req.add_field("X-Bz-Content-Sha1","#{sha1}")
    req.add_field("Content-Length",File.size(local_file))
    req.body = File.read(local_file)
    http = Net::HTTP.new(req.uri.host, req.uri.port)
    http.use_ssl = (req.uri.scheme == 'https')
    res = http.start {|http| http.request(req)}
    case res
    when Net::HTTPSuccess then
        @json = res.body
    when Net::HTTPRedirection then
        fetch(res['location'], limit - 1)
    else
        res.error!
    end
  end

  # Format of final file URL:
  # https://f001.backblazeb2.com/file/cute_pictures/cats/kitten.jpg
  # ...Which is...
  # download_url/file/bucket_name/file_name

end
