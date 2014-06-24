require 'open-uri'

class PostsController < InheritedResources::Base
  attr_accessor :deep

  def parser
    #url = "http://ru.wikipedia.org/wiki/%D0%93%D1%80%D0%B0%D1%84%D0%B8%D0%BA_%D1%84%D1%83%D0%BD%D0%BA%D1%86%D0%B8%D0%B8"
    #clear
    #url = "http://ru.wikipedia.org/wiki/%D0%94%D0%B8%D1%84%D1%84%D0%B5%D1%80%D0%B5%D0%BD%D1%86%D0%B8%D0%B0%D0%BB%D1%8C%D0%BD%D0%BE%D0%B5_%D1%83%D1%80%D0%B0%D0%B2%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5"
    #make_links(url)
    make_posts
    head :ok
  end

  protected

  def clear
    ActiveRecord::Base.connection.reset_pk_sequence!("posts")
    ActiveRecord::Base.connection.reset_pk_sequence!("links")
    Post.delete_all
    Link.delete_all
  end

  def make_posts
    Link.all.each do |l|
      doc = Nokogiri::HTML(open("http://ru.wikipedia.org#{l.url}"))
      name = doc.css("#mw-content-text p b").first.text
      content = doc.css("#mw-content-text p").first.text 
      Post.where(name: name, url: l.url, content: content).first_or_create!
    end
  end

  def make_links(url)
    doc = Nokogiri::HTML(open(url))
    name = doc.css("#mw-content-text p b").first.text
    content = doc.css("#mw-content-text p").first.text 
    links = doc.css("#mw-content-text p").first.css("a").map{ |l| [l.text, l[:href]] }
    links.each { |l| Link.where(url: l.last, value: l.first).first_or_create! }
  end
end
