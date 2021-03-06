# GlobalMapTiles

[![Gem Version](https://badge.fury.io/rb/global_map_tiles.svg)](https://badge.fury.io/rb/global_map_tiles)

![CI](https://github.com/x4d3/global_map_tiles/workflows/CI/badge.svg)

Ruby port of the script `globalmaptiles.py` from [Tiles à la Google Maps: Coordinates, Tile Bounds and Projection](http://www.maptiler.org/google-maps-coordinates-tile-bounds-projection)

Lon/Lat convention was chosen over Lat/Lon as it's the convention of [GeoJSON](https://geojson.org/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "global_map_tiles"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install global_map_tiles

## Usage

```ruby

require "global_map_tiles"

mercator = GlobalMapTiles::GlobalMercator.new
puts mercator.lon_lat_to_meters(13.24, 52.31)
puts mercator.meters_to_lon_lat(1473870.058102942, 6856372.69101939)
```

See all the examples in [spec/global_mercator_spec.rb](spec/global_mercator_spec.rb)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/x4d3/global_map_tiles.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
