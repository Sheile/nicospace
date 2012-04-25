# -*- coding:utf-8 -*-

class FlexibleTime
  attr_accessor :sequence, :year, :month, :day, :hour, :minute, :second, :header, :footer

  def initialize sequence = nil, year = nil, month = nil, day = nil, hour = nil, minute = nil, second = nil
    @sequence = sequence
    @year = Date.today.year
    @month = month
    @day = day
    @hour = hour
    @minute = minute
    @second = second
    @tbd = false
  end

  def too_old?
    condition_date = Date.today - 1.month
    return true if year? && year < condition_date.year
    return true if year? && month? && year == condition_date.year && month < condition_date.month && month > (condition_date.month - 3)
    return false
  end

  def fixed?
    year? && month? && day? && hour? && minute? && second?
  end

  def tbd?
    @tbd
  end

  def year?
    !@year.nil?
  end

  def month?
    !@month.nil?
  end

  def day?
    !@day.nil?
  end
  
  def hour?
    !@hour.nil?
  end

  def minute?
    !@minute.nil?
  end

  def second?
    !@second.nil?
  end

  def to_s isdate = true, istime = true
    text = ""
    if isdate
      if tbd?
        text << "TBD"
      else
        text << "#{@header} " if @header

        text << "#{month}月" if month?
        text << "中" if month? && !day? && !@footer
        text << "#{@footer}" if @footer

        text << "#{day}日" if day?
      end
    end

    text << " "

    if istime
      text << (hour < 12 ? "午前" : "午後") if hour?
      text << "#{hour % 12}時" if hour?
      
      text << "%02d分" % minute if minute?
    end

    text.strip!

    text = "変換失敗 #{@datestr} #{@timestr}" if text.empty?
    text
  end

  def self.parse sequence, datestr, timestr
    instance = self.new
    instance.parse sequence, datestr, timestr
    return instance
  end

  def parse sequence, datestr, timestr
    @sequence = sequence if sequence

    datestr.strip!
    timestr.strip!
    @datestr = datestr
    @timestr = timestr
    datestr, timestr = delete_metadata(datestr, timestr)

    @tbd = datestr == "TBD"
    parse_date(datestr, timestr) unless datestr == "TBD"
    parse_time(datestr, timestr) unless timestr == "TBD"

    @year = @year.to_i if year?
    @month = @month.to_i if month?
    @day = @day.to_i if day?
    @hour = @hour.to_i if hour?
    @minute = @minute.to_i if minute?
    @second = @second.to_i if second?
  end

  def getlocal
    instance = self.dup
    return instance unless instance.hour?

    instance.hour += 9
    if instance.hour >= 24
      instance.day += 1 if instance.day?
      instance.hour -= 24
    end

    return instance unless instance.year? && instance.month? && instance.day?
    if instance.day > Date.new(instance.year, instance.month, -1).day
      instance.month += 1 if instance.month?
      instance.day = 1
    end

    if instance.month > 12
      instance.year += 1 if instance.year?
      instance.month = 1
    end

    return instance
  end

  def == opponent
    return false if self.year != opponent.year
    return false if self.month != opponent.month
    return false if self.day != opponent.day
    return false if self.hour != opponent.hour
    return false if self.minute != opponent.minute
    return false if self.second != opponent.second
    return true
  end

  def equal_date? opponent
    return false if self.year != opponent.year
    return false if self.month != opponent.month
    return false if self.day != opponent.day
    return true
  end

  def <=> opponent
    return 0 if tbd? || opponent.tbd?
    return sequence <=> opponent.sequence if sequence && opponent.sequence
    return year <=> opponent.year if year? && opponent.year? && year != opponent.year
    return month <=> opponent.month if month? && opponent.month? && month != opponent.month
    return day <=> opponent.day if day? && opponent.day? && month? && opponent.month? && day != opponent.day
    return 0
  end
  
  private

  def parse_date datestr, timestr
    parse_year datestr, timestr
    parse_month datestr, timestr
    parse_day datestr, timestr
  end
  
  def parse_time datestr, timestr
    parse_hour datestr, timestr
    parse_minute datestr, timestr
    parse_second datestr, timestr
  end
  
  def delete_metadata datestr, timestr
    @header = "NET" if datestr.start_with? "NET"
    datestr.gsub!(/^NET\s+/, "")

    @footer = "前半" if datestr.start_with? "Early"
    datestr.gsub!(/^Early\s+/, "")

    @footer = "後半" if datestr.start_with? "Late"
    datestr.gsub!(/^Late\s+/, "")

    return datestr, timestr
  end

  def parse_year datestr, timestr
    @year = $2 if datestr =~ /(^|[^\d])(\d{4})($|[^\d])/
    @year = "20#{$3}" if datestr =~ /^(\d+)\/(\d+)\/(\d+)/
    @year ||= Date.today.year
  end

  def parse_month datestr, timestr
    if datestr =~ /^(\d+)\/(\d+)\/(\d+)/
      @month = $1
      return
    end

    months = {}
    (1..12).each do |i|
      months[Date::MONTHNAMES[i]] = i
      months[Date::ABBR_MONTHNAMES[i] + "."] = i
    end

    # Custom
    months["Sept."] = 9

    @month = months[$1] if datestr =~ /^([^\s]+)/
  end

  def parse_day datestr, timestr
    if datestr =~ /^(\d+)\/(\d+)\/(\d+)/
      @day = $2
      return
    end

    @day = $1 if datestr =~ /(\d+)(\/\d+)?/
    @day = $1 if timestr =~ /GMT\s+on\s+(\d+)/
  end

  def parse_hour datestr, timestr
    @hour = $1 if timestr =~ /^(\d{2})\d{2}/
  end

  def parse_minute datestr, timestr
    @minute = $1 if timestr =~ /^\d{2}(\d{2})/
  end
  
  def parse_second datestr, timestr
    # @second = 0
  end
end

