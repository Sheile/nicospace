#!/bin/env ruby
# -*- coding:utf-8 -*-

module Dictionary
module_function
  def t original
    @@dictionary ||= load_csv_to_array "#{Rails.root}/config/dictionary.txt"
    return @@dictionary[original] if @@dictionary.include? original

    @@dictionary.each do |key, value|
      original = original.gsub(Regexp.new(key.gsub(" ", "\s?")), value)
    end
    return original
  end

  def load_csv_to_array csv_path
    array = []
    open(csv_path).readlines.each do |row|
      row.chomp!
      next if row.empty? || row.match("^\s*#")

      array << row.split(",")
    end
    # キー長でソート
    array.sort! {|a, b| b[0].size <=> a[0].size }
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
