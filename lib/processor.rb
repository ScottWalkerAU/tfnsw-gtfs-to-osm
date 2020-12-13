# frozen_string_literal: true

require 'csv'
require_relative 'array'

class Processor
  READ_MODE = 'r:bom|utf-8' # Remove BOM char from header row

  IN_STOPS = 'data/stops.txt'
  SELECTED = 'out/stops.csv'
  MAPPED = 'out/stops-mapped.csv'
  IGNORED = 'out/stops-ignored.csv'

  HEADER_MAP = {
    'stop_id' => 'ref',
    'stop_name' => 'name',
    'stop_lat' => 'latitude',
    'stop_lon' => 'longitude'
  }
  COPY_MAP = {
    'ref' => 'gtfs_id'
  }
  EXTRA_HEADERS = {
    'bus' => 'yes',
    'highway' => 'bus_stop',
    'public_transport' => 'platform'
  }

  def run
    selected = []
    mapped = []
    ignored = []

    CSV.foreach(IN_STOPS, READ_MODE, headers: true) do |row|
      if ignore?(row)
        ignored << row.to_h
        next
      end

      selected << row.to_h
      mapped << map(row)
    end

    selected.to_csv(SELECTED)
    mapped.to_csv(MAPPED)
    ignored.to_csv(IGNORED)
  end

  private

  def ignore?(row)
    row['location_type'] == '1' ||
    !row['parent_station'].empty? ||
    row['stop_code'].empty?
    # TODO: Light rail stops and wharves
  end

  def map(row)
    stop = row.to_h
    # Remove ignored headers
    stop.select! { |key, _v| HEADER_MAP.keys.include?(key) }
    # Perform tag mapping
    stop.transform_keys! { |key| HEADER_MAP[key] }
    # Add in duplicate tags
    COPY_MAP.each { |orig, dupe| stop[dupe] = stop[orig] }
    # Add in additional tags
    stop.merge!(EXTRA_HEADERS)
  end
end
