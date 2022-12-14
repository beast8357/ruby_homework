class CargoCar < Car
  def initialize(volume)
    super(type: :cargo, volume: volume)
  end

  def occupy_volume(value)
    raise 'Your value is too big!' if value > free_volume

    self.occupied_volume += value
  end
end
