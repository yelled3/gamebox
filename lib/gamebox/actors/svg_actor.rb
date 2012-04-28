require "enumerator"

# SvgActor knows how to build himself based on an svg document based on the :name 
# passed in being the group name in the doc (layer).
define_behavior :svg_built do

  requires_behaviors :positioned
  requires :physics_manager

  setup do
    name = @opts[:name]
    svg_doc = @opts[:svg_doc]
    
    my_layer = svg_doc.find_group_by_label(name.to_s)
    segments = build_from_vertices my_layer.path.vertices

    actor.has_attributes segments: segments,
                         name: name
  end
  
  helpers do
    def build_from_vertices(vertices)
      
      moment_of_inertia,mass = Float::INFINITY,Float::INFINITY
      terrain_body = CP::Body.new(mass,moment_of_inertia)
      elasticity = 0
      friction = 0.7
      thickness = 6
      segments = []
      [].tap do |segments|
        vertices.each_cons(2) do |a,b|
          seg = CP::Shape::Segment.new(terrain_body, a,b, thickness)
          seg.collision_type = @name
          seg.e = elasticity
          seg.u = friction
          seg.group = :terrain
          segments << [a,b]
          physics_manager.space.add_static_shape(seg)
        end
      end
    end
  end
end

define_actor :svg_actor do
  has_behavior :svg_built

  view do
    draw do |target, x_off, y_off, z|
      actor.segments.each do |seg|
        p1 = seg[0]
        p2 = seg[1]
        # TODO pull in draw_line_s?
        target.draw_line p1.x+x_off, p1.y+y_off, p2.x+x_off, p2.y+y_off, [25,255,25,255], z
        #target.draw_line_s [p1.x+x_off,p1.y+y_off], [p2.x+x_off,p2.y+y_off], [25,255,25,255], 6
      end
    end
  end
end
