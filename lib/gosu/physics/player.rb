module Gosu
  module Physics
    class PlayerBody < Body
      def initialize(x = 50, y = 50, width = 32, height = 32)
        super(x, y, width, height)
      end

      def collision_direction(other_body)
        AABB.collision_direction(self, other_body)
      end

      def update(dt)
        super(dt)
        self.apply_gravity(dt)
      end
    end

    class BasePlayer
      attr_reader :body

      def initialize(x = 50, y = 50, width = 32, height = 32)
        @x = x
        @y = y
        @width = width
        @height = height
        @body = PlayerBody.new(x, y, width, height)
        @jump_speed = 30_000
        @jump_count = 0
        @max_jump = 2
        @move_speed = 500
      end

      def move_right(dt)
        @body.move_right(dt, @move_speed)
      end

      def move_left(dt)
        @body.move_left(dt, @move_speed)
      end

      def jump(dt)
        return if @jump_count >= @max_jump
        @body.move_up(dt, @jump_speed)
        @jump_count += 1
      end

      def reset_jump!
        @jump_count = 0
      end

      def update(dt)
        @body.update(dt)
      end

      def draw
        Gosu.draw_line(@body.x, @body.y, Gosu::Color::RED, @body.x + @width, @body.y, Gosu::Color::RED)
        Gosu.draw_line(@body.x, @body.y + @height, Gosu::Color::RED, @body.x + @width, @body.y + @height, Gosu::Color::RED)
        Gosu.draw_line(@body.x, @body.y, Gosu::Color::RED, @body.x, @body.y + @height, Gosu::Color::RED)
        Gosu.draw_line(@body.x + @height, @body.y, Gosu::Color::RED, @body.x + @width, @body.y + @width, Gosu::Color::RED)
      end
    end
  end
end
