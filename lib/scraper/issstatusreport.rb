#!/bin/env ruby
# -*- coding:utf-8 -*-

require 'fileutils'
require 'date'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'scraper/base/flexible_time.rb'
require 'scraper/base/iss_event.rb'

module Scraper
  class ISSStatusReport
    def scrap
      events = []
      repairHTML("#{Rails.root}/tmp/issstatusreport.html")

      document = Nokogiri(open("#{Rails.root}/tmp/issstatusreport.html").read)
      document.xpath("id('ullitags')//br").each do |node|
        node.add_next_sibling(Nokogiri::XML::Text.new("\n", document))
      end
      target = document.xpath("id('ullitags')").text
      target.gsub!(/.*^Significant Events Ahead/m, "")
      lines = target.split("\n")
      lines.each do |line|
        next unless line =~ /^\s*(\d{2}\/\d{2}\/\d{2}) -+ (.*)$/

        datestr = $1
        description = $2
        next if description =~ /launch/

        date = FlexibleTime.parse(nil, datestr, "")
        events << ISSEvent.new(date, description)
      end

      events
    end

    private
    def repairHTML path
      original_path = path + ".org"
      FileUtils.mv(path, original_path)
      output = open(path, "w")
      lines = open(original_path).readlines
      lines[0].gsub!(/<html/, "\n<html")

      lines.each do |line|
        output.write(line)
      end
      output.close
    end
  end
end
