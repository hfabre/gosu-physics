require "gosu"
require_relative "../lib/gosu/physics"

class Game < Gosu::Window
  def initialize
    super(1200, 900)
    self.caption = "Gosu physics showcase"

    @player = Gosu::Physics::BasePlayer.new(50, 50, 32, 32)
    @ground = Gosu::Physics::Body.new(0, 850, 1200, 50, friction: 0.97)
    @test = Gosu::Physics::Body.new(100, 50, 32, 32, friction: 0.95)
    @block = Gosu::Physics::Body.new(700, 800, 100, 50, friction: 0.95)
    @platform = Gosu::Physics::Body.new(200, 600, 300, 25, friction: 0.95)
    @last_time = Gosu::milliseconds
    @bodies = {
      player: @player,
      obstacles: [@ground, @test, @block, @platform]
    }
  end

  def update
    update_dt!
    self.close if button_down? Gosu::Button::KbEscape
    @player.move_left(@dt) if self.button_down? Gosu::Button::KbD
    @player.move_right(@dt) if self.button_down? Gosu::Button::KbA

    @bodies[:obstacles].each do |obstacle|
      if @player.body.collide?(obstacle)
        collision_direction = @player.body.collision_direction(obstacle)

        case collision_direction
        when :bottom
          @player.body.reset_speed_y if @player.body.speed_y > 0
          @player.reset_jump!
          @player.body.apply_surface_friction(obstacle)
        when :top
          @player.body.reset_speed_y if @player.body.speed_y < 0
        when :right
          @player.body.reset_speed_x if @player.body.speed_x < 0
        when :left
          @player.body.reset_speed_x if @player.body.speed_x > 0
        end
      else
        @player.body.apply_air_friction
      end
    end

    @player.update(@dt)
  end

  def button_down(id)
    @player.jump(@dt) if id == Gosu::Button::KbSpace
  end

  def update_dt!
    @current_time = Gosu::milliseconds
    @dt = @current_time - @last_time
    @last_time = @current_time

    # Fix @dt to make the game fill smoother in case of lag
    @dt = [@dt, 1 / 60.0].min
  end

  def draw
    @player.draw
    @bodies[:obstacles].each(&:draw)
  end
end

Game.new.show
