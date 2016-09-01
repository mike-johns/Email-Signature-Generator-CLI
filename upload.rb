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
    B2::upload_file
    B2::store_download_url
    show_user_feedback
  end

  def get_local_path
    puts "Drag the picture you'd like to use and drop it below, then hit RETURN."
    fix_file_name(gets.chomp!)
  end

  def fix_file_name(path)
    # Need to remove spaces etc from user-dragged image file name before upload
    # Start by saving existing path to $local_image_path
    # Finish by storing the updated name as $upload_file_name or whatever
    # Do the local path and upload file name need to be the same?
  end

  def choose_file_type

  def show_user_feedback
    puts "\nUpload complete. Your picture is stored at: #{$download_url.green}\n\n"
  end

  def api_url
    $api_url
  end

  def authorization_token
    $authorization_token
  end

  def download_url
    $download_url
  end
end
