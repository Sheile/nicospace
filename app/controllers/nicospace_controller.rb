require 'scraper/spaceflightnow'
require 'scraper/issstatusreport'
require 'scraper/combineevents'

class NicospaceController < ApplicationController
  attr_accessor :text

  include CombineEvents

  def index
    events = combine_events Scraper::SpaceFlightNow.new.scrap, Scraper::ISSStatusReport.new.scrap
    @text = events.map do |event| event.to_s end.join("\n\n")
  end

  def sample
    events = combine_events Scraper::SpaceFlightNow.new.scrap, Scraper::ISSStatusReport.new.scrap
    @text = events.map do |event| event.to_s end.join("\n\n")
  end
  
  def a2750b30ffbc7de3b362
    events = combine_events Scraper::SpaceFlightNow.new.scrap, Scraper::ISSStatusReport.new.scrap
    @text = events.map do |event| event.to_s end.join("\n\n")
  end
end
