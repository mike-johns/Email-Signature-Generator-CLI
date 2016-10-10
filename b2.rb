require 'json'
require 'net/http'
require 'digest/sha1'
require 'pp'
require_relative 'keys' # My personal account keys are stored in another file as $account_id and $application_key. Define your own in this module or a linked file.

# TODO figure out what the hell a SHA1 checksum is

module B2
  def self.authorize_account
    uri = URI("https://api.backblazeb2.com/b2api/v1/b2_authorize_account")
    req = Net::HTTP::Get.new(uri)
    req.basic_auth($account_id, $application_key)
    http = Net::HTTP.new(req.uri.host, req.uri.port)
    http.use_ssl = true
    res = http.start {|this_http| this_http.request(req)}
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
    @api_url = @json.match(/(?<="apiUrl": ").+(?=")/).to_s
    @account_token = @json.match(/(?<="authorizationToken": ").+(?=")/).to_s
    @download_url = @json.match(/(?<="downloadUrl": ").+(?=")/).to_s
    puts @download_url
  end

  def self.get_upload_url
    uri = URI("#{@api_url}/b2api/v1/b2_get_upload_url")
    req = Net::HTTP::Post.new(uri)
    req.add_field("Authorization","#{@account_token}")
    req.body = "{\"bucketId\":\"#{$bucket_id}\"}"
    http = Net::HTTP.new(req.uri.host, req.uri.port)
    http.use_ssl = true
    res = http.start {|this_http| this_http.request(req)}
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
    @upload_url = @json.match(/(?<="uploadUrl": ").+(?=")/).to_s
    @upload_token = @json.match(/(?<="authorizationToken": ").+(?=")/).to_s
  end

  def self.upload_file(local_path, sha1)
    new_name ||= rand.to_s.slice!(2..-1)
    content_type = "b2/x-auto"
    uri = URI(@upload_url)
    req = Net::HTTP::Post.new(uri)
    req.add_field("Authorization","#{@upload_token}")
    req.add_field("X-Bz-File-Name","#{new_name}")
    req.add_field("Content-Type","#{content_type}")
    req.add_field("X-Bz-Content-Sha1","#{sha1}")
    req.add_field("Content-Length",File.size(local_path))
    req.body = File.read(local_path)
    http = Net::HTTP.new(req.uri.host, req.uri.port)
    http.use_ssl = (req.uri.scheme == 'https')
    res = http.start {|this_http| this_http.request(req)}
    case res
    when Net::HTTPSuccess then
        @json = res.body
    when Net::HTTPRedirection then
        fetch(res['location'], limit - 1)
    else
        res.error!
    end
  end

  def self.get_download_url
    b2_file_name = @json.match(/(?<="fileName": ").+(?=")/).to_s
    @final_url = "#{@download_url}/file/#{$bucket_name}/#{b2_file_name}"
    @final_url
  end
end
