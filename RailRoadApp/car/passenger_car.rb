class PassengerCar < Car
  
  def initialize(seats)
    super(:passenger, seats)
  end

  def take_seat
    raise "No more free seats!" if free_volume.zero?
    self.occupied_volume += 1
  end
end