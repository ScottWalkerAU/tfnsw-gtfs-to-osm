# tfnsw-gtfs-to-osm
Process TfNSW GTFS data for OSM as per [this wiki page](https://wiki.openstreetmap.org/wiki/TfNSW_Data_Imports)

## What it does
A Ruby script that reads from the `data/` directory and outputs into `out/`.

Transforms GTFS data for TfNSW bus stops from `stops.txt` and produces:
- `stops.csv`: the raw selected stops
- `stops-mapped.csv`: the selected stops mapped into OSM tags
- `stops-ignored`: the raw ignored stops

## How to run
1. Download the latest [GTFS data](https://opendata.transport.nsw.gov.au/dataset/timetables-complete-gtfs)
2. Extract to `data/`
3. Run `ruby bin/process.rb`

### Updating suburb list
This shouldn't need to be done too often, but the steps are:
1. Obtain a new suburb export from [Overpass](https://overpass-turbo.eu) with the query `admin_level=10 in "New South Wales"`
2. Export the result as "raw OSM data" into the `suburb/` folder
3. Run `ruby bin/parse_suburbs.rb` to create the intermediate CSV
4. Run `ruby bin/merge_suburbs.rb` to conflate the two CSV files

Note: To avoid updating every line, the file may need to be resaved to remove empty strings

## Caveats
Presently unable to detect light rail stops or wharves.
