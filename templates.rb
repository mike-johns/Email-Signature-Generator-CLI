module Templates
  def generate_with_twitter
    html = <<-HEREDOC
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
            <tr><td style="padding-bottom: 2px; color: #333333; font-size: 14px; font-family: Helvetica, sans-serif; font-weight: normal;"><a href="tel:+01-#{@phone}" style=" color: #F7751F; text-decoration: none;">cell</a> | <a href="mailto:#{@first.downcase}.#{@last.downcase}@thriveschool.email" style="color: #F7751F; text-decoration: none;">email</a> | <a href="https://twitter.com/#{@twitter}" style="color: #F7751F; text-decoration: none;">twitter</a> | <a href="http://thriveschool.info" style="color: #F7751F; text-decoration: none;">web</a>
        </td>
      </tr>
    </table>
    HEREDOC
    return html
  end

  def generate_without_twitter
    html = <<-HEREDOC
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
            <tr><td style="padding-bottom: 2px; color: #333333; font-size: 14px; font-family: Helvetica, sans-serif; font-weight: normal;"><a href="tel:+01-#{@phone}" style=" color: #F7751F; text-decoration: none;">cell</a> | <a href="mailto:#{@first.downcase}.#{@last.downcase}@thriveschool.email" style="color: #F7751F; text-decoration: none;">email</a> | <a href="http://thriveschool.info" style="color: #F7751F; text-decoration: none;">web</a>
        </td>
      </tr>
    </table>
    HEREDOC
    return html
  end
end
