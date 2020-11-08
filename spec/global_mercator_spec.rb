require "spec_helper"
# If you need to generate an example using the python code from globalmaptiles.py
# https://gist.github.com/maptiler/fddb5ce33ba995d5523de9afdf8ef118
# mercator = GlobalMercator()
#
# lat = -23.561345
# lon = -46.655860
# zoom = 15
#
# mx, my = mercator.LatLonToMeters(lat, lon)
# px, py = mercator.MetersToPixels(mx, my, zoom)
# tx, ty = mercator.PixelsToTile(px, py)
#
# rx, ry = mercator.PixelsToRaster(px, py, zoom)
# gx, gy = mercator.GoogleTile(tx, ty, zoom)
#
# minLat, minLon, maxLat, maxLon = mercator.TileLatLonBounds(tx, ty, zoom)
#
# obj = {
#     "zoom": zoom,
#     "lon_lat": [lon, lat],
#     "meters": [mx, my],
#     "pixels": [px, py],
#     "raster": [rx, ry],
#     "tile": [tx, ty],
#     "google_tile": [gx, gy],
#     "tile_bounds": mercator.TileBounds(tx, ty, zoom),
#     "tile_lon_lat_bounds": [minLon, minLat, maxLon, maxLat],
#     "resolution": mercator.Resolution(zoom),
#     "quad_tree_key": mercator.QuadTree(tx, ty, zoom)
# }
# print(json.dumps(obj, indent=4))

Example = Struct.new(:zoom,
  :lon_lat,
  :meters,
  :pixels,
  :raster,
  :tile,
  :google_tile,
  :tile_bounds,
  :tile_lon_lat_bounds,
  :resolution,
  :quad_tree_key,
  keyword_init: true)

RSpec.describe GlobalMapTiles::GlobalMercator do
  shared_examples "computes values" do |example|
    let(:mercator) { described_class.new }
    let(:percent) { 0.0000001 }

    it "computes lon_lat_to_meters" do
      expect(mercator.lon_lat_to_meters(*example.lon_lat)).to(have_values_within(percent).percent_of(example.meters))
    end

    it "computes meters_to_lon_lat" do
      expect(mercator.meters_to_lon_lat(*example.meters)).to(have_values_within(percent).percent_of(example.lon_lat))
    end

    it "computes pixels_to_meters" do
      expect(mercator.pixels_to_meters(*example.pixels, example.zoom)).to(have_values_within(percent).percent_of(example.meters))
    end

    it "computes meters_to_pixels" do
      expect(mercator.meters_to_pixels(*example.meters, example.zoom)).to(have_values_within(percent).percent_of(example.pixels))
    end

    it "computes pixels_to_tile" do
      expect(mercator.pixels_to_tile(*example.pixels)).to(have_values_within(percent).percent_of(example.tile))
    end

    it "computes pixels_to_raster" do
      expect(mercator.pixels_to_raster(*example.pixels, example.zoom)).to(have_values_within(percent).percent_of(example.raster))
    end

    it "computes meters_to_tile" do
      expect(mercator.meters_to_tile(*example.meters, example.zoom)).to(have_values_within(percent).percent_of(example.tile))
    end

    it "computes tile_bounds" do
      expect(mercator.tile_bounds(*example.tile, example.zoom)).to(have_values_within(percent).percent_of(example.tile_bounds))
    end

    it "computes tile_lat_lon_bounds" do
      expect(mercator.tile_lon_lat_bounds(*example.tile, example.zoom)).to(have_values_within(percent).percent_of(example.tile_lon_lat_bounds))
    end

    it "computes resolution" do
      expect(mercator.resolution(example.zoom)).to(eq(example.resolution))
    end

    it "computes google_tile" do
      expect(mercator.google_tile(*example.tile, example.zoom)).to(have_values_within(percent).percent_of(example.google_tile))
    end

    it "computes quad_tree_key" do
      expect(mercator.quad_tree_key(*example.tile, example.zoom)).to(eq(example.quad_tree_key))
    end
  end

  describe "Test 1: Berlin, zoom 1" do
    include_examples "computes values",
      Example.new(
        zoom: 1,
        lon_lat: [13.24, 52.31],
        meters: [1473870.058102942, 6856372.69101939],
        pixels: [274.83022222222223, 343.59728898790985],
        raster: [274.83022222222223, 168.40271101209015],
        tile: [1, 1],
        google_tile: [1, 0],
        tile_bounds: [0, 0, 20037508.342789244, 20037508.342789244],
        tile_lon_lat_bounds: [0, 0, 180.0, 85.0511287798066],
        resolution: 78271.51696402048,
        quad_tree_key: "1"
      )
  end

  describe "Test 2: Berlin, zoom 7" do
    include_examples "computes values",
      Example.new(
        zoom: 7,
        lon_lat: [13.24, 52.31],
        meters: [1473870.058102942, 6856372.69101939],
        pixels: [17589.134222222223, 21990.22649522623],
        raster: [17589.134222222223, 10777.77350477377],
        tile: [68, 85],
        google_tile: [68, 42],
        tile_bounds: [1252344.271424327, 6574807.42497772, 1565430.3392804079, 6887893.492833804],
        tile_lon_lat_bounds: [11.249999999999993, 50.73645513701064, 14.062499999999986, 52.482780222078226],
        resolution: 1222.99245256282,
        quad_tree_key: "1202120"
      )
  end

  describe "Test 3: Berlin, zoom 11" do
    include_examples "computes values",
      Example.new(
        zoom: 11,
        lon_lat: [13.24, 52.31],
        meters: [1473870.058102942, 6856372.69101939],
        pixels: [281426.14755555557, 351843.6239236197],
        raster: [281426.14755555557, 172444.37607638031],
        tile: [1099, 1374],
        google_tile: [1099, 673],
        tile_bounds: [1467590.943075385, 6848757.734351791, 1487158.8223163895, 6868325.613592796],
        tile_lon_lat_bounds: [13.183593750000007, 52.26815737376817, 13.359375000000002, 52.3755991766591],
        resolution: 76.43702828517625,
        quad_tree_key: "12021201013"
      )
  end

  describe "Test 4: Berlin, zoom 15" do
    include_examples "computes values",
      Example.new(
        zoom: 15,
        lon_lat: [13.24, 52.31],
        meters: [1473870.058102942, 6856372.69101939],
        pixels: [4502818.360888889, 5629497.982777915],
        raster: [4502818.360888889, 2759110.017222085],
        tile: [17589, 21990],
        google_tile: [17589, 10777],
        tile_bounds: [1473705.905338198, 6856095.68906717, 1474928.8977907598, 6857318.681519732],
        tile_lon_lat_bounds: [13.238525390624998, 52.308478623663355, 13.24951171874999, 52.315195264379575],
        resolution: 4.777314267823516,
        quad_tree_key: "120212010132103"
      )
  end
  describe "Test 5: Museum of Art of São Paulo Assis Chateaubriand, Zoom 15" do
    include_examples "computes values",
      Example.new(
        zoom: 15,
        lon_lat: [
          -46.65586,
          -23.561345
        ],
        meters: [
          -5193706.577722261,
          -2700046.461502878
        ],
        pixels: [
          3107143.6654364443,
          3629123.16613935
        ],
        raster: [
          3107143.6654364443,
          4759484.833860651
        ],
        tile: [
          12137,
          14176
        ],
        google_tile: [
          12137,
          18591
        ],
        tile_bounds: [
          -5194048.946034297,
          -2700367.3352587074,
          -5192825.953581734,
          -2699144.3428061455
        ],
        tile_lon_lat_bounds: [
          -46.658935546875,
          -23.563987128451217,
          -46.64794921875,
          -23.553916518321625
        ],
        resolution: 4.777314267823516,
        quad_tree_key: "210311121123223"
      )
  end
end
