# signature_generator.rb
# Used to create HTML files for custom Thrive School staff signatures
#
# Core HTML is from HubSpot's free email signature generator: http://www.hubspot.com/email-signature-generator
# They're an awesome company and you should support them.
#
# Copyright (c) <2016> <Mike Johns>
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Define Signature class, whose methods actually create the signature object.

class Signature
  attr_reader :file_name

  def initialize(options = {})
    @first = options[:first].capitalize
    @last = options[:last].capitalize
    @title = options[:title].capitalize
    @phone = options[:phone]
    @twitter = options[:twitter] ? options[:twitter].downcase : false
    @image_link = options[:image_link]
    create_file
    generate_html
    @file_name
  end

  def create_file
    @file_name = "#{@first.downcase}-#{@last.downcase}-signature.html"
    @signature_file = File.open(@file_name, "w")
  end

  def close_file
    @signature_file.close
  end

  def generate_html
    @signature_file.puts generate_first_section
    @signature_file.puts generate_twitter
    @signature_file.puts generate_last_section
    close_file
    move_file
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

  def move_file
    system("mv #{@file_name} ~/Desktop/")
  end
end

# Create command line user interface to walk the user through data entry

puts ""
puts "Hey there!"
puts "I'll walk you through creating your email signature one step at a time."
puts ""

puts "What's your first name?"
first_name = gets.chomp!

puts "Sounds good, #{first_name}. Your last name?"
last_name = gets.chomp!

puts "Great! What's your title at Thrive School?"
title_entry = gets.chomp!

puts "What's your phone number?"
puts ">>> Write it out like this: 916-869-5309"
phone_entry = gets.chomp!

puts "Do you have a Twitter account?"
puts ">>> Enter yes or no"
twitter_bool = gets.chomp!
if twitter_bool.upcase != "NO"
  puts "What's your username?"
  puts ">>> Don't worry about the @"
  twitter_entry = gets.chomp!
end

puts "Alright, #{first_name}, we're almost done!"
puts ""

puts "Now let's grab a profile picture."
puts "Do you have a link ready?"
puts ">>> Enter yes or no"
url_bool = gets.chomp!
if url_bool.upcase != "NO"
  puts "Paste it here."
  puts ">>> The whole thing, starting with http"
  url_entry = gets.chomp!
else
  puts "No worries. You can leave this window open until you do."
  puts "Paste it here when you're ready:"
  url_entry = gets.chomp!
end

puts "Starting HTML creation process..."

result = Signature.new first: first_name, last: last_name, title: title_entry, phone: phone_entry, twitter: twitter_entry, image_link: url_entry

puts "Done"
puts "There's a new file on your Desktop called #{result.file_name}"
puts "Here's how to add it to your Gmail:"
puts ">>> Press 'return' to move on to the next step"
puts "Step 1: Double-click the file"
x = gets
puts "Step 2: Use Command-A to 'Select All' that shows up (your awesome new signature)"
x = gets
puts "Step 3: Go to your Gmail settings"
x = gets
puts "Step 4: Paste the signature you already copied into the 'Email Signature' box"
x = gets
puts "Step 5: Hit 'Save'"
x = gets
puts "You're done! Anything sent from Gmail.com will now include your new signature."
puts ""
puts "You can now quit this application."
