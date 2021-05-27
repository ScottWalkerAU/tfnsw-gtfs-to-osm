# tfnsw-gtfs-to-osm
Process TfNSW GTFS data for OSM as per [this wiki page](https://wiki.openstreetmap.org/wiki/TfNSW_Data_Imports)

## What it does
A Ruby script that reads from the `data/` directory and outputs into `out/`.

Transforms GTFS data for TfNSW bus stops from `stops.txt` and produces:
- `stops-raw.csv`: the raw selected stops
- `stops-mapped.csv`: the selected stops mapped into OSM tags
- `stops-ignored.csv`: the raw ignored stops

## How to run
1. Download the latest [GTFS data](https://opendata.transport.nsw.gov.au/dataset/timetables-complete-gtfs)
2. Extract to `data/`
3. Run `ruby bin/process.rb`

### Updating Progress
Initial imports are being done suburb-by-suburb.

After this, delta imports may be done on a Local Government Area (LGA) basis.
Note: some suburbs are split across multiple LGAs

## Caveats
Presently unable to detect light rail stops or wharves.
These should be omitted manually during the import, with the aid of local or contextual knowledge.
