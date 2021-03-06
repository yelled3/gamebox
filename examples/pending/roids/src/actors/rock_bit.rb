
define_behavior :rocky_bit do
  requires :director

  setup do
    actor.has_attributes view: 'graphical_actor_view'
    actor.body.a -= rand(10)
    @speed = (rand(2)+1)/6.0 * 50
    @turn_speed = rand(2)*0.00004 
    x = (rand-0.5) * 2
    y = (rand-0.5) * 2
    @dir = vec2(x,y)

    #bits only live for 500-1000
    @ttl = 500+rand(500)
    director.when :update do |time|
      update time
    end
  end

  helpers do
    def update(time)
      @ttl -= time
      actor.remove if @ttl < 0
      actor.body.w += time*@turn_speed
      actor.body.apply_impulse(@dir*time*@speed, ZERO_VEC_2) if actor.body.v.length < 400
    end
  end
end


define_actor :rock_bit do
  has_behaviors :animated, :physical => {:shape => :circle, 
    :mass => 0.5,
    :radius => 10}
  has_behaviors :rocky_bit

end
