#!/bin/env ruby
# -*- coding:utf-8 -*-

module Dictionary
module_function
  def t original
    @@dictionary ||= load_csv_to_hash "#{Rails.root}/config/dictionary.txt"
    return @@dictionary[original] if @@dictionary.include? original
    key = @@dictionary.keys.find do |key| original.include? key end
    return original.gsub(key, @@dictionary[key]) unless key.nil?
    return nil
  end

  def load_csv_to_array csv_path
    array = []
    open(csv_path).readlines.each do |row|
      row.chomp!
      next if row.empty? || row.match("^\s*#")

      array << row.split(",")
    end
    array
  end

  def load_csv_to_hash csv_path
    hash = {}
    open(csv_path).readlines.each do |row|
      row.chomp!
      next if row.empty? || row.match("^\s*#")

      key, value = row.split(',')
      hash[key] = value
    end
    hash
  end
end
