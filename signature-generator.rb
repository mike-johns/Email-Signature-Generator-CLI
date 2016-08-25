# signature_generator.rb

class Signature

  def initialize(options = {})
    @first = options[:first].capitalize
    @last = options[:last].capitalize
    @title = options[:title].capitalize
    @phone = options[:phone]
    @twitter = options[:twitter] ? options[:twitter].downcase : false
    @image_link = options[:image_link]
    create_file
    generate_html
  end

  def create_file
    file_name = "#{@first.downcase}-#{@last.downcase}-signature.html"
    @signature_file = File.open(file_name, "w")
  end

  def close_file
    @signature_file.close
  end

  def generate_html
    @signature_file.puts generate_first_section
    @signature_file.puts generate_twitter
    @signature_file.puts generate_last_section
    close_file
  end

  def generate_first_section
    # Top of file until Twitter name
    section_a = <<-HEREDOC
    <table cellpadding="0" cellspacing="0" border="0" style="background: none; border-width: 0px; border: 0px; margin: 0; padding: 0;">
      <tr>
        <td valign="top" style="padding-top: 0; padding-bottom: 0; padding-left: 0; padding-right: 7px; border-top: 0; border-bottom: 0: border-left: 0; border-right: solid 3px #333333">
          <table cellpadding="0" cellspacing="0" border="0" style="background: none; border-width: 0px; border: 0px; margin: 0; padding: 0;">
            <tr><img id="preview-image-url" src="#{@image_link}" height="70" width="70" style="border-radius: 35px;"></tr>
          </table>
        </td>
        <td style="padding-top: 0; padding-bottom: 0; padding-left: 12px; padding-right: 0;">
          <table cellpadding="0" cellspacing="0" border="0" style="background: none; border-width: 0px; border: 0px; margin: 0; padding: 0;">
            <tr><td style="padding-bottom: 5px; color: #333333; font-size: 18px; font-family: Helvetica, sans-serif;"><strong>#{@first} #{@last}</strong></td></tr>
            <tr><td style="padding-bottom: 5px; color: #333333; font-size: 14px; font-family: Helvetica, sans-serif;">#{@title}, <strong>Thrive School</strong></td></tr>
            <tr><td style="padding-bottom: 2px; color: #333333; font-size: 14px; font-family: Helvetica, sans-serif; font-weight: normal;"><a href="tel:+01-#{@phone}" style=" color: #F7751F; text-decoration: none;">cell</a> | <a href="mailto:#{@first.downcase}.#{@last.downcase}@thriveschool.email" style="color: #F7751F; text-decoration: none;">email</a> |
    HEREDOC
  end

  def generate_twitter
    if (!@twitter)
      twitter_section = ""
    else
      twitter_section = <<-HEREDOC
       <a href="https://twitter.com/#{@twitter}" style="color: #F7751F; text-decoration: none;">twitter</a> |
      HEREDOC
    end
    return twitter_section
  end

  def generate_last_section
    section_c = <<-HEREDOC
     <a href="http://thriveschool.info" style="color: #F7751F; text-decoration: none;">web</a></td></tr>
 </table>
</td>
</tr>
</table>
    HEREDOC
  end
end
