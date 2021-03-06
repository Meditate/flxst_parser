require 'open-uri'
require 'nokogiri'
require 'json'

url = "https://www.flixster.com/"
html = open(url)
doc = Nokogiri::HTML(html)
listing = []
doc.css('.carousel').each do |block|
  movies_in_category = []
  category = block.at_css('.carousel-heading h2').text
  block.css('.carousel-item').each do |movie|
    title = movie.css('.movie-title').text
    metric = movie.css('.tomatometer-and-date').text.delete("\n").split("%")
    # Set movie rating, if presents:
    if metric.size > 1
      rate = (metric.first. + "%").delete(" ")
    else
      rate = "unrated"
    end
    date = metric.last.delete(", ")
    movies_in_category.push(
      title: title,
      rate: rate,
      date: date
    )
  end
  h = {}
  h[category] = movies_in_category
  listing << h
end

puts JSON.pretty_generate(listing)
