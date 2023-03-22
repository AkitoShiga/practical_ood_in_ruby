class Trip
  attr_reader :bicycles, :customers, :vehicle

  def prepare(preparers)
    preparers.each do |preparer|
      preparer.prepare_trip(self) # interface 自分ごと渡してメッセージの受けてに取得してもらう => 知識をへらす
    end
  end
end

# すべての準備者（Preparer）は prepare_tripに応答するダック
class Mechanic
  def prepare_trip(trip)
    trip.bicycles.each{ |bicycle| prepare_bicycle(bicycle) }
  end

  def prepare_bicycle
  end
end


class TripCoordinator
  def prepare_trip(trip)
    buy_food(trip.customers)
  end

  def buy_food
  end
end

class Driver
  def prepare_trip(trip)
    vehicle = trip.vehicle

    gas_up(vehicle)
    fil_water_tank(vehicle)
  end
end