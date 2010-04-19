require 'spatial_hash'

class SpatialStagehand < Stagehand

  DEFAULT_PARAMS = {
    :cell_size = 50
  }
  def setup
    merged_opts = DEFAULT_PARAMS.merge opts
    @spatial_actors = SpatialHash.new merged_opts[:cell_size]
  end

  def cell_size
    @spatial_actors.cell_size
  end

  def add(actor)
    @spatial_actors.add actor
  end

  def remove(actor)
    @spatial_actors.remove actor
  end

  def update(time)
    @spatial_actors.rehash
  end

  def items_at(x,y)
    @spatial_actors.items_at x, y
  end

  def items_in(x,y,w,h)
    @spatial_actors.items_in x, y, w, h
  end

end
