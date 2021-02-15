# frozen_string_literal: true

class Mapper
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

  class << self
    def map(stop)
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
end
