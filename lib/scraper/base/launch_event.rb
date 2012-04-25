# -*- coding:utf-8 -*-

class LaunchEvent
  def initialize start_date, end_date, vehicle, organization
    @start_date = start_date
    @end_date = end_date
    @vehicle = vehicle
    @organization = organization || vehicle.organization
  end

  def to_s
    text = ""
    text << '▲ <b>'
    text << '<font color="#de0010">' if @vehicle.important?
    text << @start_date.getlocal.to_s
    if @start_date != @end_date
      text << "～"

      if @start_date.equal_date?(@end_date)
        text << (@end_date.getlocal.to_s false, true)
      else
        text << (@end_date.getlocal.to_s true, true)
      end
    end
    text << " #{@vehicle}"
    text << '</font>' if @vehicle.important?
    text << " by #{@organization}</b><br>"
  end

  def date
    @start_date
  end

  def <=> event
    date <=> event.date
  end
end

