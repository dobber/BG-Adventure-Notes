#!/usr/bin/env ruby

require 'rubygems'
require 'rdiscount'
require 'fileutils'
include FileUtils

ebookconvert='/Applications/calibre.app/Contents/MacOS/ebook-convert'
book_filename='bg-adventure-notes'

book_title='Записки по българските приключения'
authors='Сборник разкази'
licence='Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported'
language='bg'

unless File.exist?(ebookconvert)
  puts "Please install calibre command line tools first!"
  exit 0
end

if ARGV.length != 1
  puts "You need to specify book format (all, fb2, mobi, epub, html).\nFor example: ./makebook epub"
  exit 0
end

format=ARGV[0] 

# define methods
def to_book(cmd, format)
  ebookcmd=cmd.gsub(/format/, "#{format}")
  system (ebookcmd)
end

#begin main()
book_content = %(<html xmlns="http://www.w3.org/1999/xhtml"><head><title>#{book_title}</title></head><body>)
dir = File.expand_path(File.join(File.dirname(__FILE__), 'books'))
Dir[File.join(dir, '**')].sort.each do |booksdir|
  Dir[File.join(booksdir, '*.txt')].sort.each do |input|
    puts "processing #{input}"
    content = File.read(input)
    content.gsub!(/Insert\s(.*?)\.jpg/, '![\1](' + booksdir + '/Images/\1.jpg)')
    book_content << RDiscount.new(content).to_html
    end
end

book_content << "</body></html>"

File.open("#{book_filename}.html", 'w') do |output|
  output.write(book_content)
end

cmd="#{ebookconvert} #{book_filename}.html #{book_filename}.format --cover 'cover.jpg' --authors '#{authors}' --comments '#{licence}' --level1-toc //h:h1 --level2-toc //h:h2 --level3-toc //h:h3 --language #{language} --change-justification=justify"

if format == 'all'
  to_book(cmd, 'mobi')
  to_book(cmd, 'epub')
  to_book(cmd, 'fb2')
elsif format == 'mobi'
  to_book(cmd, format)
elsif format == 'epub'
  to_book(cmd, format)
elsif format == 'fb2'
  to_book(cmd, format)
elsif format =='html'
  # return nothing, just exit
else
  puts "Please select one of epub, mobi, fb2, html, all"
  exit 0
end
