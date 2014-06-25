require 'open-uri'

class PostsController < InheritedResources::Base
  def parser
    clear(false)
    parse(10)
    head :ok
  end

  protected

  def clear(flag)
    ActiveRecord::Base.connection.reset_pk_sequence!("posts")
    ActiveRecord::Base.connection.reset_pk_sequence!("links")
    if flag
      Post.delete_all
      Link.delete_all
      url = "http://ru.wikipedia.org/wiki/%D0%94%D0%B8%D1%84%D1%84%D0%B5%D1%80%D0%B5%D0%BD%D1%86%D0%B8%D0%B0%D0%BB%D1%8C%D0%BD%D0%BE%D0%B5_%D1%83%D1%80%D0%B0%D0%B2%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5"
      value = "Дифференциальное уравнение"
      Link.where(url: url, value: value).first_or_create!
    end
  end

  def parse(limit)
    links = Link.all.limit(limit)
    links.each do |l|
      doc = Nokogiri::HTML(open(l.url))
      name = doc.css("#mw-content-text p b").first.text
      content = doc.css("#mw-content-text p").first.text 
      Post.where(name: name, url: l.url, content: content).first_or_create!
      links = doc.css("#mw-content-text p").first.css("a").map{ |l| [l.text, "http://ru.wikipedia.org#{l[:href]}"] }
      links.each { |l| Link.where(url: l.last, value: l.first).first_or_create! }
    end
  end
end
