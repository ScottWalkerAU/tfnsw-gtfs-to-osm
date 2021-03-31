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

  NAME_MAP = {
    'After' => 'after',
    'And' => 'and', # Legacy
    'At' => 'at',
    'Before' => 'before',
    'Opp' => 'opposite',
    'Opp.' => 'opposite',
    'Av' => 'Avenue',
    'Bvd' => 'Boulevard',
    'Cct' => 'Circuit',
    'Ch' => 'Chase',
    'Cir' => 'Circle',
    'Cl' => 'Close',
    'Cr' => 'Crescent',
    'Cres' => 'Crescent',
    'Ct' => 'Court',
    'Dr' => 'Drive',
    'Gr' => 'Grove',
    'Gdns' => 'Gardens',
    'Hwy' => 'Highway',
    'La' => 'Lane',
    'Mt' => 'Mount',
    'Mwy' => 'Motorway',
    'Nth' => 'North',
    'Pde' => 'Parade',
    'Pkwy' => 'Parkway',
    'Pl' => 'Place',
    'Rd' => 'Road',
    'Sgt' => 'Sergeant',
    'St' => 'Street',
    'Sth' => 'South',
    'Tce' => 'Terrace',
    'Trk' => 'Track',
    'Twy' => 'T-Way'
  }

  class << self
    def map(row)
      stop = row.to_h
      remove_ignored_headers!(stop)
      transform_tags!(stop)
      add_duplicate_tags!(stop)
      add_additional_tags!(stop)
      map_name!(stop)
      stop
    end

    private

    def remove_ignored_headers!(stop)
      stop.select! { |key, _v| HEADER_MAP.keys.include?(key) }
    end

    def transform_tags!(stop)
      stop.transform_keys! { |key| HEADER_MAP[key] }
    end

    def add_duplicate_tags!(stop)
      COPY_MAP.each { |orig, dupe| stop[dupe] = stop[orig] }
    end

    def add_additional_tags!(stop)
      stop.merge!(EXTRA_HEADERS)
    end

    def map_name!(stop)
      # Formatting fix where a space does not follow a comma (6 occurrences @ 2021-12-16)
      name = stop['name'].gsub(/,(?=\w)/, ', ')

      parts = name.split.map do |word|
        w = word.sub(',', '')
        next word unless NAME_MAP.include?(w)

        word.sub(w, NAME_MAP[w])
      end
      stop['name'] = parts.join(' ')
    end
  end
end
