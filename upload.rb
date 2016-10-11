require 'digest'
require_relative 'colorizr'
require_relative 'b2'

class Upload
  include B2

  def initialize
    B2::authorize_account
    B2::store_account_urls
    get_local_path
    B2::get_upload_url
    B2::store_upload_url
    generate_hash
    B2::upload_file(@path, @hash)
    @final_url = B2::get_download_url
    puts "Successfully uploaded image to: #{@final_url}".green
  end

  def get_local_path
    puts "Drag the picture you'd like to use and drop it below, then hit RETURN."
    until @path != nil
      temp_path = gets.chomp!.chop!
      if !temp_path.chars.include?(" ")
        @path = temp_path
      else
        puts "The file name must not contain spaces.".red
        puts "Rename the file or double-check the path, and try again."
      end
    end
  end

  def generate_hash
    puts "Generating SHA1 Checksum".blue
    @hash = Digest::SHA1.file(@path)
    puts "Successfully generated checksum: #{@hash}".green
  end

  def final_url
    @final_url
  end
end
