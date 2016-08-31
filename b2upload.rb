require_relative 'colorizr'

class B2Upload
  attr_reader :returned_url

  def initialize
    get_local_path
    upload_image
    show_user_feedback
  end

  def get_local_path
    puts "Drag the picture you'd like to use and drop it below, then hit RETURN."
    @local_image_path = gets.chomp!
  end

  def upload_image
    @returned_url = "http://b2.backblaze.com/your-cool-pic"
  end

  def show_user_feedback
    puts "\nUpload complete. Your picture is stored at: #{@returned_url.green}\n\n"
  end
end

#
#
# STEP ONE
#
# B2::authorize_account

require 'json'
require 'net/http'

require_relative 'keys' # My personal account keys are stored in another file here. Just replace $account_id and $application_key below and remove this line.

account_id = $account_id # Obtained from your B2 account page.
application_key = $application_key # Obtained from your B2 account page.
uri = URI("https://api.backblazeb2.com/b2api/v1/b2_authorize_account")
req = Net::HTTP::Get.new(uri)
req.basic_auth(account_id, application_key)
http = Net::HTTP.new(req.uri.host, req.uri.port)
http.use_ssl = true
res = http.start {|http| http.request(req)}
case res
when Net::HTTPSuccess then
    json = res.body
when Net::HTTPRedirection then
    fetch(res['location'], limit - 1)
else
    res.error!
end

# @api_url = json["apiUrl"]
# @authentication_token = json["authorizationToken"]
# Also need to have @bucketId previously set

#
#
# STEP TWO
#
# B2::get_upload_url

require 'json'
require 'net/http'

api_url = "" # Provided by b2_authorize_account
account_authorization_token = "" # Provided by b2_authorize_account
bucket_id = "" # The ID of the bucket you want to upload your file to
uri = URI("#{api_url}/b2api/v1/b2_get_upload_url")
req = Net::HTTP::Post.new(uri)
req.add_field("Authorization","#{account_authorization_token}")
req.body = "{\"bucketId\":\"#{bucket_id}\"}"
http = Net::HTTP.new(req.uri.host, req.uri.port)
http.use_ssl = true
res = http.start {|http| http.request(req)}
case res
when Net::HTTPSuccess then
    res.body # Need to manually add json =
when Net::HTTPRedirection then
    fetch(res['location'], limit - 1)
else
    res.error!
end

# @upload_url = json["uploadUrl"]

#
#
# STEP THREE
#
# B2::upload_file

require 'json'
require 'net/http'
require 'digest/sha1'

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
    res.body
when Net::HTTPRedirection then
    fetch(res['location'], limit - 1)
else
    res.error!
end

# Format of final file URL:
# https://f001.backblazeb2.com/file/cute_pictures/cats/kitten.jpg
# ...Which is...
# download_url/file/bucket_name/file_name
