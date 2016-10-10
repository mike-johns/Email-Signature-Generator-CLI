require 'digest'
require_relative 'b2'

class Upload
  include B2

  attr_accessor

  def initialize
    B2::authorize_account
    B2::store_account_urls
    get_local_path
    B2::get_upload_url
    B2::store_upload_url
    B2::upload_file(@path, generate_hash)
    B2::download_url
  end

  def get_local_path
    puts "Drag the picture you'd like to use and drop it below, then hit RETURN."
    @path = gets.chomp!
  end

  def generate_hash
    Digest::SHA1.file @path
  end
end
