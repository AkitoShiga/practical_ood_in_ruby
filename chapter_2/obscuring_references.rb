class ObscuringReferences
  attr_reader :data
  def initialize(data)
    @data = data
  end

  def diameters
    # 0はリム、1はタイヤ
    # 配列の構造に依存している
    # 配列の構造が変われば変更が必要になる
    data.collect  { |cell| cell[0] + (cell[1] * 2) }
  end
end

# 初期化に複雑なデータ構造が必要になってしまう
# どのインデックスに何があるか送りて受けて双方が知っていなければいけない
obscuring_reference = ObscuringReferences.new([[622, 20], [622, 23], [599, 30], [599, 40]])
p obscuring_reference.diameters

class RevealingReferences
  attr_reader :wheels
  def initialize(data)
    @wheels = wheelify(data)
  end

  def diameters
    # diametersはwheelの内部構造についてなにもしらない
    #wheels.collect { |wheel| wheel.rim + (wheel.tire + 2) } # 1.wheelsの繰り返し処理 2.wheelの直径を計算

    wheels.collet{ |wheel| diameter(wheel) } # 1.wheelsの繰り返し処理
  end

  def diameter(wheel)
    wheel.rim + (wheel.tire * 2) # 2.wheelの直径を計算
  end

  Wheel = Struct.new(:rim, :tire)

  # @return Array<Wheel>
  def wheelify(data)
    data.collect{ |cell| Wheel.new(cell[0], cell[1]) }
  end
end