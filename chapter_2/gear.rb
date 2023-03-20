class Gear
  #attr_reader :chain_ring, :cog, :rim, :tire
  attr_reader :chain_ring, :cog, :wheel

  def initialize(chain_ring, cog, rim, tire)
    @chain_ring = chain_ring # 自転車の前の方
    @cog = cog # タイヤの後ろの方
    #@rim = rim # リムの直径
    #@tire = tire # タイヤの厚み
    @wheel = Wheel.new(rim, tire)

  end

  def ratio
    chain_ring / cog.to_f
  end

  # ギアインチ = 車輪の直径*ギア比
  def gear_inches
    # タイヤはリムの周りを囲むので直径を計算するためには2倍する
    #ratio * (rim + (tire * 2)) # 1.車輪の直径を計算している 2.ギアインチを計算している
    #ratio * diameter
    ratio * wheel.diameter
  end

  # def diameter
  #   rim + (tire * 2)
  # end

  Wheel = Struct.new(:rim, :tire) do  # StructとしてGearの中にWheelを埋め込むことで、Wheelに関する決定（クラスにするか否か）を遅らせている
    def diameter
      rim + (tire * 2)
    end
  end
end

p Gear.new(52, 11, 26, 1.5).gear_inches
p Gear.new(52, 11, 24, 1.25).gear_inches

# p Gear.new(52, 11,).ratio # 属性を追加すると以前の呼び出し部分は動かなくなる

# 車輪の円周が必要という新しい要件が追加になったことでWheelを別のクラスに切り出すという決定ができた
Object.class_eval{ remove_const :Gear }


class Gear
  attr_reader :chain_ring, :cog, :wheel

  def initialize(chain_ring, cog, wheel=nil) # ここがポイント
    @chain_ring = chain_ring
    @cog = cog
    @wheel = wheel
  end

  def ratio
    chain_ring / cog.to_f
  end

  def gear_inches
    ratio * wheel.diameter
  end
end

class Wheel
  attr_reader :rim, :tire

  def initialize(rim, tire)
    @rim = rim
    @tire = tire
  end

  def diameter
    rim + (tire * 2)
  end

  def circumference
    diameter * Math::PI
  end
end

@wheel = Wheel.new(26, 1.5)
p @wheel.circumference
puts Gear.new(52, 11, @wheel).gear_inches

puts Gear.new(52, 11).ratio