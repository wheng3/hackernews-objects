# Start coding your hackernews scraper here!
require 'open-uri'
require 'nokogiri'
require 'byebug'

class Post
	attr_accessor :title, :url, :points, :item_id, :comments
	def initialize(title, url, points, item_id, comments = [])
		@title = title
		@url = url
		@points = points
		@item_id = item_id
		@comments = comments
	end

	def add_comment(comment)
		self.comments << comment
	end
end

class Comment
	attr_accessor :description
	def initialize(description = '')
		@description = description
	end
end

# Run the program with the following syntax:
# ruby scraping_building_obj.rb 'https://news.ycombinator.com/item?id=5003980'
url = ARGV[0]
html = open(url)
doc = Nokogiri::HTML(File.open(html))
title = doc.search('.title a')[0].text
url = doc.search('.title a')[0]['href']
points = doc.search('.subtext .score')[0].text
item_id = doc.search('.subtext .hnuser')[0].text
post = Post.new(title, url, points, item_id)
doc.search('.comment-tree .comment .c00').map do |comment|
	post.comments << Comment.new(comment.text)
end

puts 'Post title: ' + post.title
puts 'Number of comments: ' + post.comments.count.to_s

