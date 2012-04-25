#!/bin/env ruby
# -*- coding:utf-8 -*-

require 'date'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'scraper/base/vehicle.rb'
require 'scraper/base/flexible_time.rb'
require 'scraper/base/launch_event.rb'

module Scraper
  class SpaceFlightNow
    def scrap
      events = []
      document = Nokogiri(open("#{Rails.root}/tmp/index.html").read)

      rewind_count = 0
      last_month = 0
      rows = document.xpath("//img[@src='images/launchschedule.gif']/parent::td/descendant::tr").to_a[0..-1]
      rows.each_slice(3) do |header, detail, dummy|
        vehicle_name, payload = header.xpath("td[2]/font/b").text().gsub(/\302\240|\n/, "").split("\302\225")
        vehicle = Vehicle.new(vehicle_name, payload)

        datestr = header.xpath("td[1]/font/b").text()
        timestr = detail.text().gsub("\n", "").match("Launch.*?(time|window|times|windows):(.*)Launch.*?site:")[2]
        start_date = FlexibleTime.parse(events.size, datestr, timestr.gsub(/\-\d{4}/, ""))
        end_date = FlexibleTime.parse(events.size, datestr, timestr.gsub(/\d{4}\-/, ""))

        if start_date.month?
          rewind_count += 1 if start_date.month < last_month
          last_month = start_date.month
        end
        start_date.year = Date.today.year + rewind_count
        end_date.year = Date.today.year + rewind_count

        org = organization detail.text().gsub("\n", "")
        events << LaunchEvent.new(start_date, end_date, vehicle, org)
      end
      events
    end

    private
    def organization detail
      @@organizations ||= Dictionary::load_csv_to_hash "#{Rails.root}/config/org_via_detail.txt"
      @@organizations.each_pair do |pattern, org|
        return org if detail.match(pattern)
      end
      nil
    end
  end
end
