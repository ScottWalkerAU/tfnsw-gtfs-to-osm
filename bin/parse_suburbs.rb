# frozen_string_literal: true

require 'csv'
require 'json'
require_relative '../lib/array'

EXPORT='suburbs/export.json'
PARSED='suburbs/parsed.csv'

def run
  data = JSON.parse(File.read(EXPORT))
  rows = collate_suburbs(data)
  rows.to_csv!(PARSED)
end

def collate_suburbs(data)
  rows = data['elements'].map do |suburb|
    next unless suburb['type'] == 'relation'

    suburb_hash(suburb['tags'])
  end
  rows.compact!
  rows.reject! { |s| ![nil, '2'].include? s[:postcode].chars.first } # empty or 2xxx postcodes only
  rows.sort_by { |s| [s[:postcode], s[:name]] }
end

def suburb_hash(tags)
  {
    name: tags['name'],
    postcode: tags['postal_code'] || '',
    last_processed: nil,
    changesets: nil
  }
end

run
