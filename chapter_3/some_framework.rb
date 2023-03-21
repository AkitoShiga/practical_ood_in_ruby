
########################################
# 外部のライブラリ、必ず固定順の引数を要求する
########################################
module SomeFrameWork
  class Gear
    attr_reader :chain_ring, :cog, :wheel
    def initialize(chain_ring, cog, wheel)
      @chain_ring = chain_ring
      @cog = cog
      @wheel = wheel
    end
  end
end
########################################



# 外部のインターフェースをラップして自身を変更から守る
module GearWrapper # moduleにすることでGearWrapperのインスタンスをつくらないという意図を明示することができる
  def self.gear(args) # ここでハッシュで引数を受け取れるようにラップする
    SomeFrameWork::Gear.new( args[:chain_ring], args[:cog], args[:wheel] )
  end
end

# 引数を持つハッシュを渡してGearのインスタンスを作成出来るようになった
gear = GearWrapper.gear(chain_ring: 52, cog: 11, wheel: Wheel.new(26, 1.5).gear_inches)
