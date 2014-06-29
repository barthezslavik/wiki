class Post < ActiveRecord::Base
  def morphology
    base = content.split
    objects = []
    properties = []
    base.each do |b|
      next if %w(с в не бы и или все).include? b
      objects << b
      properties << b if %w(ое ой).any? { |x| b.ends_with?(x) }
    end
    { base: base, properties: properties }
  end
end
