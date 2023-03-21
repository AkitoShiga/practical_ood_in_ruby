class Gear
  #attr_reader :chain_ring, :cog, :rim, :tire # Wheelの属性を受け取っている
  attr_reader :chain_ring, :cog, :wheel
  #def initialize(chain_ring, cog, rim, tire) # Wheelの初期化変数を受け取っている

=begin
  def initialize(chain_ring, cog, wheel) # 引数の順番で依存を生んでいる
    @chain_ring = chain_ring
    @cog = cog
    # @rim = rim
    # @tire = tire
    @wheel = wheel
  end
=end
  def initialize(args) # 冗長になるが、不確実な未来への影響を防ぐ
    # @chain_ring = args[:chain_ring]
    # @cog = args[:cog] || 18
    # @wheel = args[:wheel]

    # デフォルト値 || よりいい
    # @chain_ring = args.fetch(:chain_ring, 40)
    # @cog = args.fetch(:cog, 18)
    # @wheel = args[:wheel]

    # デフォルトメソッド
    args = defaults.merge(args) # 引数をハッシュで受け取るとこのテクニックが使える
    @chain_ring = args[:chain_ring]
    @cog = args[:cog]
    @wheel = args[:wheel]
  end

  def defaults
    { chain_ring: 40, cog: 18 } # 引数の値が複雑なときに有効
  end

  def gear_inches
    #ratio * Wheel.new(rim, tire).diameter # Gearの中でWheelをnewしている
    # Wheelクラスを知っている
    # Wheelクラスのdiameterを知っている
    # Wheelクラスの引数を知っている
    # Wheelクラスの引数の順番を知っている

    #ratio * wheel.diameter # wheelはdiameterに応答するということだけを知る。wheelに依存している。外部クラスを知り、またそのメッセージに依存している。
    ratio * diameter
  end

  def diameter
    wheel.diameter # wheelへの参照をこの一箇所に集中して隔離する
  end

  def ratio
    chain_ring / cog.to_f
  end
end

class Wheel
  attr_reader :rim, :tire

  def initialize(rim ,tire)
    @rim = rim
    @tire = tire
  end

  def diameter
    rim * (tire * 2)
  end
end

#p Gear.new(52, 11, 26, 1.5).gear_inches
#p Gear.new(52, 11, Wheel.new(26, 1.5)).gear_inches # 引数の順番に依存している
p Gear.new({
             chain_ring: 52,
             cog: 11,
             wheel: Wheel.new(26, 1.5)
           }).gear_inches

# 1 他のクラスの名前 --> GearはWheelという名前のクラスがあることを予想している
# 2 self以外のどこかに送ろうとするメッセージの名前 --> GearはWheelのインスタンスがdiameterに応答することを予想している
# 3 メッセージが要求する引数 --> GearはWheel.newの引数がrimとtireであることを知っている
# 4 それらお引数の順番 --> GearはWheel.newの最初の引数がrimで、2番目がtireである必要があることを知っている

# 一定の依存関係は避けられないが、不必要な依存はコードの合理性を損なう
# 依存するほど一つのエンティティのように振る舞い、再利用ができなくなっていく