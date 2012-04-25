# -*- coding:utf-8 -*-

class ISSEvent
  def initialize date, description
    @date = date
    @description = description
  end

  def to_s
    description = translation(@description)
    "△ #{@date.to_s(true, false)} #{description}<br>"
  end

  def date
    @date
  end

  def <=> event
    date <=> event.date
  end

  private
  def translation original
    @@dictionary ||= Dictionary::load_csv_to_array "#{Rails.root}/config/dictionary_iss.txt"
    @@dictionary.each do |row|
      original.gsub!(Regexp.new(row[0]), row[1])
    end
    original
  end
end

