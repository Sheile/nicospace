# -*- coding:utf-8 -*-

class TextEvent
  def initialize date, text
    @date = date
    @text = text
  end

  def to_s
    @text + "<br>"
  end

  def date
    @date
  end

  def <=> event
    date <=> event.date
  end
end

