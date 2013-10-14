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
Dir[File.join(dir, '**', '*.txt')].sort.each do |input|
  puts "processing #{input}"
  content = File.read(input)
  content.gsub!(/Insert\s18333fig\d+\.jpg\s*\n.*?(\d{1,2})-(\d{1,2})\. (.*)/, '![\1.\2 \3](dir/Images/\1.\2.jpg "\1.\2 \3")')
  book_content << RDiscount.new(content).to_html
end

book_content << "</body></html>"
File.open("bg-adventure-notes.html", 'w') do |output|
  output.write(book_content)
end