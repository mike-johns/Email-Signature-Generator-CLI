# Email Signature Generator
# Used to create HTML files for custom Thrive School staff signatures
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

# Begin command line user interface to walk the user through data entry
puts ""
puts "Hey there!"
puts "I'll walk you through creating your email signature one step at a time."
puts ""

puts "What's your first name?"
first_name = gets.chomp!

puts "Sounds good, #{first_name}. Your last name?"
last_name = gets.chomp!

puts "Great! What's your title?"
title_entry = gets.chomp!

puts "What's your phone number?"
puts ">>> Write it out like this: 916-867-5309"
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

# Take user input and create new Email Signature HTML file.
result = Signature.new first: first_name, last: last_name, title: title_entry, phone: phone_entry, twitter: twitter_entry, image_link: url_entry

puts "Done"
puts "There's a new file on your Desktop called #{result.file_name}"
