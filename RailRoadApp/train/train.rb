require_relative "../modules/manufacturer"
require_relative "../modules/instance_counter"

class Train
  include Manufacturer
  include InstanceCounter

  @@trains = {}

  def self.find(number)
    trains[number]
  end

  attr_reader :number, :type, :speed, :cars, :trains, 
              :route, :current_station

  NUMBER_FORMAT = /^[a-z\d]{3}-?[a-z\d]{2}$/i

  def initialize(number, type = nil)
    @number = number
    @type = type
    validate!
    @speed = 0
    @cars = []
    @@trains[number] = self
    register_instance
  end

  def gain_speed(value)
    speed += value
  end

  def brake(value)
    speed -= value
    speed = 0 if speed < 0
  end

  def add_car(car)
    cars << car if speed == 0 && car.type == type
  end

  def unhook_car
    cars.pop if speed == 0 && cars.size > 0
  end

  def take_route(route)
    @route = route
    @current_station = @route.stations.first
    @current_station.take_train(self)
  end

  def to_next_station
    change_current_station(next_station)
  end  

  def to_previous_station
    change_current_station(previous_station)
  end

  def next_station
    condition = route.stations[current_station_index] != route.stations.last
    route.stations[current_station_index + 1] if condition
  end

  def previous_station
    condition = route.stations[current_station_index] != route.stations.first
    route.stations[current_station_index - 1] if condition
  end

  def change_current_station(station)
    @current_station.send_train(self)
    @current_station = station
    @current_station.take_train(self)
  end

  def current_station_index
    route.stations.index(current_station)
  end

  private
  def validate!
    raise "InputError: Invalid number format." if @number !~ NUMBER_FORMAT
    raise "NilTypeError: Nil type." if @type.nil?
  end
end