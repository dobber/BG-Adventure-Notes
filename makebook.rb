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

if ARGV.length == 0
  puts "You need to specify book format (all, fb2, mobi, epub, html).\nFor example: ./makebook epub"
  exit
end

format=ARGV[0] 

# define methods
def to_book(cmd, format)
  cmd.gsub!(/format/, "#{format}")
  system (cmd)
end

#begin main()
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

File.open("#{book_filename}.html", 'w') do |output|
  output.write(book_content)
end

cmd="#{ebookconvert} #{book_filename}.html #{book_filename}.format --authors '#{authors}' --comments '#{licence}' --level1-toc //h:h1 --level2-toc //h:h2 --level3-toc //h:h3 --language #{language}"

if format == 'all'
  to_book(cmd,'mobi')
  to_book(cmd,'epub')
  to_book(cmd,'fb2')
elsif format == 'mobi'
  to_book(cmd,format)
elsif format == 'epub'
  to_book(cmd,format)
elsif format == 'fb2'
  to_book(cmd,format)
elsif format =='html'
else
  exit 0
end
