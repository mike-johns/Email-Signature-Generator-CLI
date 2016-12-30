# Email Signature Generator
# Used to create HTML files for custom email signatures.
#
# HTML in templates.rb was originally generated with HubSpot's free email signature generator (http://www.hubspot.com/email-signature-generator) and has been modified.
#
# Starter code for the Backblaze B2 API in b2.rb was provided by Backblaze and has been modified.
#
# Copyright (c) <2016> <Mike Johns>
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require_relative 'signature'
require_relative 'upload'
require_relative 'colorizr'

# Begin command line user interface to walk the user through data entry.

puts "".blue
puts "\n\n\n\n\n\n\n\n\n\n\n\nRuby Email Signature Generator".green
puts "\nUsing ".blue + "Backblaze B2 ".red + "Storage and ".blue + "HubSpot".yellow + "'s Starter HTML".blue
puts "\n\nJust answer some quick questions and your awesome new HTML signature will be created for you!"
puts "Type your response and hit " + "RETURN ".green + "to move on."

puts "\n\nFirst name:"
first_name = gets.chomp!

puts "\n\nLast name:"
last_name = gets.chomp!

puts "\n\nTitle:"
title_entry = gets.chomp!

puts "\n\nCompany:"
puts "(Leave blank for Thrive School.)"
company_entry = gets.chomp!

puts "\n\nPhone Number:"
puts "(Like This: 916-867-5309)"
phone_entry = gets.chomp!

puts "\n\nEmail Address:"
email_entry = gets.chomp!

puts "\n\nTwitter Account:"
puts "(Don't include the '@'. Leave blank if you don't want it in your signature.)"
twitter_entry = gets.chomp!

# Upload the user's headshot image.

upload = Upload.new

# Take user input and create a new email signature HTML file.

result = Signature.new first: first_name, last: last_name, title: title_entry, company: company_entry, phone: phone_entry, email: email_entry, twitter: twitter_entry, image_link: upload.final_url

puts "\n\n--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--".green
puts "Your new signature, " + "#{result.file_name}".green + ", is ready on your Desktop!"
puts "--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--".green
