class B2Upload
  def initialize

  end
  def get_local_path
    puts "Drag the picture you'd like it to use and drop it below, then hit RETURN."
    @local_image_path = gets.chomp!
    @local_image_path
  end
  def upload_image

  end
end
