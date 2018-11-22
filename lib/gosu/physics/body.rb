module Gosu
  module Physics
    class Body
      attr_accessor :speed_x, :speed_y
      attr_reader :width, :height, :friction, :x, :y

      def initialize(x, y, width, height, friction: 0.98)
        @x = x
        @y = y
        @width = width
        @height = height
        @friction = friction
        @speed_x = 0
        @speed_y = 0
      end

      def move_left(dt, speed)
        @speed_x = @speed_x + dt * speed
      end

      def move_right(dt, speed)
        @speed_x = @speed_x - dt * speed
      end

      def move_up(dt, speed)
        @speed_y = @speed_y - dt * speed
      end

      def move_down(dt, speed)
        @speed_y = @speed_y + dt * speed
      end

      def apply_gravity(dt)
        @speed_y = @speed_y + dt * AABB::GRAVITY
      end

      def apply_air_friction
        @speed_x = @speed_x * AABB::FRICTION
        @speed_y = @speed_y * AABB::FRICTION
      end

      def apply_surface_friction(surface)
        @speed_x = @speed_x * surface.friction
        @speed_y = @speed_y * surface.friction
      end

      def reset_speed_x
        @speed_x = 0
      end

      def reset_speed_y
        @speed_y = 0
      end

      def update(dt)
        # limit_speed!
        @x = @x + dt * @speed_x
        @y = @y + dt * @speed_y
      end

      def collide?(other_body)
        AABB.collide?(self, other_body)
      end

      def draw
        Gosu.draw_line(@x, @y, Gosu::Color::GREEN, @x + @width, @y, Gosu::Color::GREEN)
        Gosu.draw_line(@x, @y + @height, Gosu::Color::GREEN, @x + @width, @y + @height, Gosu::Color::GREEN)
        Gosu.draw_line(@x, @y, Gosu::Color::GREEN, @x, @y + @height, Gosu::Color::GREEN)
        Gosu.draw_line(@x + @width, @y, Gosu::Color::GREEN, @x + @width, @y + @height, Gosu::Color::GREEN)
      end

      def to_s
        "center #{center} - half_size #{@half_size}"
      end

      def to_h
        {
          x: @x,
          y: @y,
          width: @width,
          height: @height,
          friction: @friction,
          speed_x: @speed_x,
          speed_y: @speed_y
        }
      end

      private

      # def limit_speed!
      #   d = Math.sqrt(@speed_x * @speed_x + @speed_y * @speed_y)
      #   return if d < @max_speed
      #
      #   n = 1 / d * @max_speed
      #   @speed_x = @speed_x * n
      #   @speed_y = @speed_y * n
      # end
    end
  end
end
