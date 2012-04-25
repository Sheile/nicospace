# -*- coding:utf-8 -*-
require 'scraper/base/text_event'
module CombineEvents
  def combine_events spaceflightnow_events, issstatusreport_events
text_events = []

=begin
    text = '☆ <b><font color="#009e00">'
    text << '12月24日 午後18時10分頃 国際宇宙ステーション(ISS)が日本上空を通過</font></b> (<a href="http://atnd.org/events/11029">http://atnd.org/events/11029</a>)'
    text_events = [TextEvent.new(FlexibleTime.new(false, 2010, 12, 24, 18, 10), text)]
=end
    sorted_events = (issstatusreport_events + text_events).sort

    result = []
    spaceflightnow_events.each do |event|
      unless sorted_events.empty?
        if (event <=> sorted_events.first) > 0
          result << sorted_events.shift
          redo
        end
      end
      result << event
    end
    result += sorted_events
      
    # 一ヶ月以上過去のイベントを削除
    result.reject! do |event|
      lambda {
        return false unless event.class == ISSEvent
        return event.date.too_old?
      }.call
    end
    result
  end
end
