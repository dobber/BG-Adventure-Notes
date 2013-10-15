#!/usr/bin/env ruby

require 'rubygems'
require 'rdiscount'
require 'fileutils'
include FileUtils

if ARGV.length == 0
  puts "you need to specify book format (mobi, epub, html). For example: ./makebook epub"
  exit
end

format=ARGV[0] 

book_title='Записки по българските приключения'
authors='Сборник разкази'
licence='Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported'

book_content = %(<html xmlns="http://www.w3.org/1999/xhtml"><head><title>#{book_title}</title></head><body>)
dir = File.expand_path(File.join(File.dirname(__FILE__), 'books'))
Dir[File.join(dir, '**')].sort.each do |booksdir|
  Dir[File.join(booksdir, '*.txt')].sort.each do |input|
    puts "processing #{input}"
    content = File.read(input)
    content.gsub!(/Insert\s(\d+)\.jpg/, '![\1](' + booksdir + '/Images/\1.jpg)')
    book_content << RDiscount.new(content).to_html
    end
end

book_content << "</body></html>"

File.open("bg-adventure-notes.html", 'w') do |output|
  output.write(book_content)
end