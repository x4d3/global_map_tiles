module GlobalMapTiles
  # based on EPSG:900913 = EPSG:3785
  class GlobalMercator
    def initialize(tile_size = 256)
      @tile_size = tile_size
      @initial_resolution = 2 * Math::PI * 6378137 / @tile_size
      @origin_shift = 2 * Math::PI * 6378137 / 2.0
    end

    # Converts given lon/lat in WGS84 Datum to XY in Spherical Mercator EPSG:900913
    def lon_lat_to_meters(lon, lat)
      mx = lon * @origin_shift / 180.0
      my = Math.log(Math.tan((90 + lat) * Math::PI / 360.0)) / (Math::PI / 180.0)

      my = my * @origin_shift / 180.0
      [mx, my]
    end

    # Converts XY point from Spherical Mercator EPSG:900913 to lon/lat in WGS84 Datum"
    def meters_to_lon_lat(mx, my)
      lon = (mx / @origin_shift) * 180.0
      lat = (my / @origin_shift) * 180.0

      lat = 180 / Math::PI * (2 * Math.atan(Math.exp(lat * Math::PI / 180.0)) - Math::PI / 2.0)
      [lon, lat]
    end

    # Converts pixel coordinates in given zoom level of pyramid to EPSG:900913
    def pixels_to_meters(px, py, zoom)
      res = resolution(zoom)
      mx = px * res - @origin_shift
      my = py * res - @origin_shift
      [mx, my]
    end

    # Converts EPSG:900913 to pyramid pixel coordinates in given zoom level
    def meters_to_pixels(mx, my, zoom)
      res = resolution(zoom)
      px = (mx + @origin_shift) / res
      py = (my + @origin_shift) / res
      [px, py]
    end

    # Returns a tile covering region in given pixel coordinates
    def pixels_to_tile(px, py)
      tx = (px / @tile_size.to_f).ceil.to_i - 1
      ty = (py / @tile_size.to_f).ceil.to_i - 1
      [tx, ty]
    end

    # Move the origin of pixel coordinates to top-left corner
    def pixels_to_raster(px, py, zoom)
      map_size = @tile_size << zoom
      [px, map_size - py]
    end

    # returns tile for given mercator coordinates
    def meters_to_tile(mx, my, zoom)
      px, py = meters_to_pixels(mx, my, zoom)
      pixels_to_tile(px, py)
    end

    # Returns bounds of the given tile in EPSG:900913 coordinates
    def tile_bounds(tx, ty, zoom)
      min_x, min_y = pixels_to_meters(tx * @tile_size, ty * @tile_size, zoom)
      max_x, max_y = pixels_to_meters((tx + 1) * @tile_size, (ty + 1) * @tile_size, zoom)
      [min_x, min_y, max_x, max_y]
    end

    # Returns bounds of the given tile in longitude/latitude using WGS84 datum
    def tile_lon_lat_bounds(tx, ty, zoom)
      bounds = tile_bounds(tx, ty, zoom)
      min_lon, min_lat = meters_to_lon_lat(bounds[0], bounds[1])
      max_lon, max_lat = meters_to_lon_lat(bounds[2], bounds[3])

      [min_lon, min_lat, max_lon, max_lat]
    end

    # Resolution (meters/pixel) for given zoom level (measured at Equator)
    def resolution(zoom)
      @initial_resolution / (2**zoom)
    end

    # "Maximal scaledown zoom of the pyramid closest to the pixelSize.
    def zoom_for_pixel_size(pixel_size)
      (1..30).each do |i|
        if pixel_size > resolution(i)
          return i != 0 ? (i - 1) : 0
        end
      end
    end

    # Converts TMS tile coordinates to Google Tile coordinates
    def google_tile(tx, ty, zoom)
      [tx, (2**zoom - 1) - ty]
    end

    # Converts TMS tile coordinates to Microsoft QuadTree
    def quad_tree_key(tx, ty, zoom)
      quad_key = ""
      ty = (2**zoom - 1) - ty
      i = zoom
      while i > 0
        digit = 0
        mask = 1 << (i - 1)
        digit += 1 if (tx & mask) != 0
        digit += 2 if (ty & mask) != 0
        quad_key += digit.to_s
        i -= 1
      end
      quad_key
    end
  end
end
