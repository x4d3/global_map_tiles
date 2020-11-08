module GlobalMapTiles
  # Functions necessary for generation of global tiles in Plate Carre projection, EPSG:4326, "unprojected profile".
  class GlobalGeodetic
    def initialize(tile_size = 256)
      @tile_size = tile_size
    end

    # Converts lon/lat to pixel coordinates in given zoom of the EPSG:4326 pyramid
    def lon_lat_to_pixels(lon, lat, zoom)
      res = 180 / 256.0 / 2**zoom
      px = (180 + lat) / res
      py = (90 + lon) / res
      [px, py]
    end

    # Returns coordinates of the tile covering region in pixel coordinates
    def pixels_to_tile(px, py)
      tx = ((px / @tile_size.to_f).ceil - 1).to_i
      ty = ((py / @tile_size.to_f).ceil - 1).to_i
      [tx, ty]
    end

    # Resolution (arc/pixel) for given zoom level (measured at Equator)"
    def resolution(zoom)
      (180 / 256.0) / 2**zoom
    end

    # Returns bounds of the given tile
    def tile_bounds(tx, ty, zoom)
      res = 180 / 256.0 / 2**zoom
      [
        tx * 256 * res - 180,
        ty * 256 * res - 90,
        (tx + 1) * 256 * res - 180,
        (ty + 1) * 256 * res - 90
      ]
    end
  end
end
