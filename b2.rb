require 'json'
require 'net/http'
require 'digest/sha1'
require_relative 'colorizr'
require_relative 'keys' # The following keys are stored in an external file and, since they relate to my personal account, are only referenced here: $account_id $application_key $bucket_id $bucket_name

module B2

  def self.authorize_account
    puts "BEGIN: ".yellow + "Authorize B2 Account".blue
    uri = URI("https://api.backblazeb2.com/b2api/v1/b2_authorize_account")
    req = Net::HTTP::Get.new(uri)
    req.basic_auth($account_id, $application_key)
    http = Net::HTTP.new(req.uri.host, req.uri.port)
    http.use_ssl = true
    res = http.start {|this_http| this_http.request(req)}
    case res
    when Net::HTTPSuccess then
        @json = res.body
        puts "HTTP GET Request: ".blue + "SUCCESS".green
    when Net::HTTPRedirection then
        fetch(res['location'], limit - 1)
        puts "HTTP GET Request: ".blue + "REDIRECTED".yellow
    else
        puts "HTTP GET Request: ".blue + "ERROR".red
        res.error!
    end
    puts "END: ".green + "Authorize B2 Account".blue
  end

  def self.store_account_urls
    puts "BEGIN: ".yellow + "Store Account URLs".blue
    @api_url = @json.match(/(?<="apiUrl": ").+(?=")/).to_s
    @account_token = @json.match(/(?<="authorizationToken": ").+(?=")/).to_s
    @download_url = @json.match(/(?<="downloadUrl": ").+(?=")/).to_s
    puts "END: ".green + "Store Account URLs".blue
  end

  def self.get_upload_url
    puts "BEGIN: ".yellow + "Request Upload URLs".blue
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
        puts "HTTP POST Request: ".blue + "SUCCESS".green
    when Net::HTTPRedirection then
        fetch(res['location'], limit - 1)
        puts "HTTP POST Request: ".blue + "REDIRECTED".yellow
    else
        puts "HTTP POST Request: ".blue + "ERROR".red
        res.error!
    end
    puts "END: ".green + "Request Upload URLs".blue
  end

  def self.store_upload_url
    puts "BEGIN: ".yellow + "Store Upload URLs".blue
    @upload_url = @json.match(/(?<="uploadUrl": ").+(?=")/).to_s
    @upload_token = @json.match(/(?<="authorizationToken": ").+(?=")/).to_s
    puts "END: ".green + "Store Upload URLs".blue
  end

  def self.upload_file(local_path, sha1)
    puts "BEGIN: ".yellow + "Upload File".blue
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
        puts "HTTP POST Request: ".blue + "SUCCESS".green
    when Net::HTTPRedirection then
        fetch(res['location'], limit - 1)
        puts "HTTP POST Request: ".blue + "REDIRECTED".yellow
    else
        puts "HTTP POST Request: ".blue + "ERROR".red
        res.error!
    end
    puts "END: ".green + "Upload File".blue
  end

  def self.get_download_url
    puts "BEGIN: ".yellow + "Get Download URL Reference".blue
    b2_file_name = @json.match(/(?<="fileName": ").+(?=")/).to_s
    @final_url = "#{@download_url}/file/#{$bucket_name}/#{b2_file_name}"
    puts "END: ".green + "Get Download URL Reference".blue
    @final_url
  end
end
