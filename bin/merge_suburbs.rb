# frozen_string_literal: true

require 'csv'
require_relative '../lib/array'

PARSED='progress/parsed.csv'
MASTER='progress/suburbs.csv'

def run
  master = read_csv(MASTER)
  parsed = read_csv(PARSED)

  master = merge!(master, parsed)
  master.to_csv!(MASTER)
end

def read_csv(path)
  CSV.read(path, headers: true, nil_value: '').map(&:to_h)
rescue Errno::ENOENT
  puts "#{path} not found"
  nil
end

# Not efficient but whatever
def merge!(master, parsed)
  return parsed if master.nil?

  parsed.each do |new|
    old = master.find { |r| match?(r, new) }
    if old.nil?
      puts "Adding #{new['name']}, #{new['postcode']}"
      master << new
    end
  end
  master.sort_by { |s| [s['postcode'], s['name']] }
end

def match?(old, new)
  old['name'] == new['name'] && (old['postcode'] == new['postcode'] || old['postcode'].nil?)
end

run
