require 'digest'
require_relative 'colorizr'
require_relative 'b2'

class Upload
  include B2

  attr_accessor

  def initialize
    puts "auth account"
    B2::authorize_account
    puts "store account urls"
    B2::store_account_urls
    puts "get local path"
    get_local_path
    puts "get upload url"
    B2::get_upload_url
    puts "store upload url"
    B2::store_upload_url
    puts "generate hash"
    generate_hash
    puts "upload file"
    B2::upload_file(@path, @hash)
    puts "get download url"
    B2::get_download_url
    @final_url
  end

  def get_local_path
    puts "Drag the picture you'd like to use and drop it below, then hit RETURN."
    puts "IMPORTANT!".red
    puts "The file name must not contain spaces."
    until @path != nil
      temp_path = gets.chomp!.chop!
      if !temp_path.chars.include?(" ")
        @path = temp_path
      else
        puts "That file path included a space. Please rename the file with no spaces, check the path, and try again."
      end
    end
    puts @path
  end

  def generate_hash
    puts "generating hash"
    @hash = Digest::SHA1.file(@path)
    puts "hash: #{@hash}"
  end
end
