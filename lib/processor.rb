# frozen_string_literal: true

require 'csv'
require_relative 'array'
require_relative 'mapper'

class Processor
  READ_MODE = 'r:bom|utf-8' # Remove BOM char from header row

  IN_STOPS = 'data/stops.txt'
  SELECTED = 'out/stops-raw.csv'
  MAPPED = 'out/stops-mapped.csv'
  IGNORED = 'out/stops-ignored.csv'

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
      mapped << Mapper.map(row)
    end

    selected.to_csv!(SELECTED)
    mapped.to_csv!(MAPPED)
    ignored.to_csv!(IGNORED)
  end

  private

  def ignore?(row)
    row['location_type'] == '1' ||
    !row['parent_station'].empty? ||
    row['stop_code'].empty?
    # TODO: Light rail stops and wharves
  end
end
