class Trip
  attr_reader :bicycles, :customers, :vehicle

  # このmechanic引数はどんなクラスのものでもよい
=begin
  def prepare(mechanic)
    # @@@prepare_bicycleに応答できるオブジェクトを受け取るということに依存している@@@

    # mechanicが自転車を用意してくると信じている
    mechanic.prepare_bicycles(bicycles)
  end
=end
  def prepare(preparers)
    preparers.each do |preparer|
      # クラスごとに応答できるメッセージとの受け取れる引数に依存している
      case preaparer
      when Mechanic
        preparer.prepare_bicycles(bicycles)
      when TripCoordinator
        preparer.buy_food(customers)
      when Driver
        preparer.gas_up(vehicle)
        preparr.fill_water_tank(vehicle)
      end
    end
  end
end

class Mechanic
  def prepare_bicycles(bicycles)
    bicycles.each { |bicycle| prepare_bicycle(bicycle) }
  end

  def prepare_bicycle(bicycle)
  end
end

class TripCoordinator
  def buy_food(customers)
  end
end

class Driver
  def gas_up(vehicle)
  end

  def fill_water_tank(vehicle)
  end
end
