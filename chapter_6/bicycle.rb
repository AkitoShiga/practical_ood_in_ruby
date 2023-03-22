class Bicycle
  attr_reader :size, :tape_color

  def initialize(args)
    @size = args[:size]
    @tape_color = args[:tape_color]
  end

  # すべての自動車はデフォルト値として同じタイヤサイズとチェーンサイズを持つ
  def spares
    {
      chain: '10-speed',
      tire_size: '23',
      tape_color: tape_color
    }
  end
end

bike = Bicycle.new(size: 'M', tape_color: 'red')
#p bike.size
#p bike.spares

# マウンテンバイクが追加になった
Object.class_eval{ remove_const :Bicycle }

class Bicycle
  attr_reader :style,
              :size,
              :tape_color,
              :front_shock,
              :rear_shock

  def initialize(args)
    @style       = args[:style]
    @size        = args[:size]
    @tape_color  = args[:tape_color]
    @front_shock = args[:front_shock]
    @rear_shock  = args[:rear_shock]
  end

  # styleの確認は危険な道へ進む一歩 アンチパターン
  def spares
    if style == :road
      { chain:      '10-speed',
        tire_size:  '23', # millimeters
        tape_color: tape_color }
    else
      { chain:      '10-speed',
        tire_size:  '2.1', # inches
        rear_shock: rear_shock }
    end
  end
end

bike = Bicycle.new(style: :mountain,
                   size: 'S',
                   front_shock: 'Manitou',
                   rear_shock: 'Fox')

#p bike.spares

class MountainBike < Bicycle
  attr_reader :front_shock, :rear_shock

  def initialize(args)
    @front_shock = args[:front_shock]
    @rear_shock = args[:rear_shock]
    super(args)
  end

  def spares
    super.merge(rear_shock: rear_shock)
  end
end

mountain_bike = MountainBike.new(
  size: 'S',
  front_shock: 'Manitou',
  rear_shock: 'Fox'
)

#p mountain_bike.spares

Object.class_eval{ remove_const :Bicycle }
Object.class_eval{ remove_const :MountainBike }

class Bicycle
  attr_reader :size, :chain, :tire_size # RoadBikeから昇格

  def initialize(args={})
    @size = args[:size] # RoadBikeから昇格
    @chain = args[:chain] || default_chain
    @tire_size = args[:tire_size] || default_tire_size

    post_initialize(args)
  end

  def post_initialize(args)
    nil
  end

  def default_chain
    '10-speed'
  end

  def default_tire_size
    raise NotImplementedError, "This #{self.class} cannot respond to: #{__method__}"
  end

  def spares
    { tire_size: tire_size,
      chain: chain
    }.merge(local_spares) # フックメソッド
  end

  def local_spares
    {}
  end
end

# サブクラスへ降格
class RoadBike < Bicycle
  attr_reader :style, :tape_color

  # def initialize(args)
  #   @tape_color  = args[:tape_color]
  #   super(args) # superに依存している
  # end

  def post_initialize(args)
    # 何を初期化するかについての責任は負うが、いつ初期化を行うかについての責任から開放する
    @tape_color = args[:tape_color]
  end


  def default_tire_size
    '23'
  end


  # styleの確認は危険な道へ進む一歩 アンチパターン
  # def spares
  #   if style == :road
  #     { chain:      '10-speed',
  #       tire_size:  '23', # millimeters
  #       tape_color: tape_color }
  #   else
  #     { chain:      '10-speed',
  #       tire_size:  '2.1', # inches
  #       rear_shock: rear_shock }
  #   end
  # end
  def local_spares
    { tape_color: tape_color }
  end
end

class MountainBike < Bicycle
  attr_reader :front_shock, :rear_shock

  def post_initialize(args)
    @front_shock = args[:front_shock]
    @rear_shock = args[:rear_shock]
  end

  def default_tire_size
    '2.1'
  end

  def local_spares
    { rear_shock: rear_shock }
  end
end

class RecumbentBike < Bicycle
  attr_reader :flag

  def post_initialize(args)
    @flag = args[:flag]
  end

  def default_chain
    '9-size'
  end

  def default_tire_size
    '28'
  end

  def local_spares
    { flag: flag }
  end
end

bent = RecumbentBike.new(flag: 'tall and orange')
p bent.spares

# 共通メソッドでサブクラス固有の振る舞いを呼び出すようにする
# 初期化変数のデフォルト値を呼び出すメソッドを定義する
# サブクラスはそこにデフォルト値を定義する
# サブクラスは固有の振る舞いのみを定義出来るようにする
# 変更される部分に固有の振る舞いを設定できるようなメソッドを定義して、基底クラスで呼び出す
