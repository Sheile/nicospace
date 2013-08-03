# -*- coding:utf-8 -*-

require 'scraper/base/dictionary'

class Vehicle
  IMPORTANT_VEHICLE = ["Shuttle Discovery", "Shuttle Atlantis", "Shuttle Endeavour", "H-2A", "H-2B", "Epsilon"]
  IMPORTANT_PAYLOAD = [/ISS [0-9]+S/]

  include Dictionary

  def initialize(name, payload)
    @name = name
    @payload = payload
  end

  def organization
    @@organizations ||= load_csv_to_hash "#{Rails.root}/config/org_via_vehicle.txt"
    @@organizations.each do |key, value|
      return value if @name.include? key
    end
    return "XXXX"
  end

  def important?
    return true if IMPORTANT_VEHICLE.any? do |pattern| @name.match(pattern) end
    return true if IMPORTANT_PAYLOAD.any? do |pattern| @payload.match(pattern) end
    return false
  end

  def to_s
    text = ""
    text << "#{t(@name) || @name} "
    text << "[#{t(@payload) || @payload}] "
    text << "打上げ"
  end
end

