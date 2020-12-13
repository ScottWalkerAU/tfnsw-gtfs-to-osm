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

## Caveats
Presently unable to detect light rail stops or wharves.
