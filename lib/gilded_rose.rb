class GildedRose
  module Inventory
    module Handlers
      module Substract
        def self.execute(value)
          value - 1
        end
      end

      module Quality
        module Add
          MAX_QUALITY = 50

          def self.execute(quality)
            quality < MAX_QUALITY ? quality + 1 : quality
          end
        end

        module Substract
          MIN_QUALITY = 0

          def self.execute(quality)
            quality > MIN_QUALITY ? quality - 1 : quality
          end
        end
      end

      module Reset
        def self.execute(_value)
          0
        end
      end

      module DoNothing
        def self.execute(value)
          value
        end
      end

      class Multiplier
        def initialize(multiplier, handler)
          @multiplier = multiplier
          @handler = handler
        end

        def execute(value)
          @multiplier.times { value = @handler.execute(value) }
          value
        end
      end
    end

    class GoodsFactory
      def self.for(item)
        case item.name
        when 'Aged Brie'
          AgedBrie.build(item.sell_in, item.quality)
        when 'Backstage passes to a TAFKAL80ETC concert'
          BackstagePass.build(item.sell_in, item.quality)
        when 'Conjured Mana Cake'
          Conjured.build(item.sell_in, item.quality)
        when 'Sulfuras, Hand of Ragnaros'
          Good.new(item.sell_in, item.quality, sell_in_handler: Handlers::DoNothing,
                                               quality_handler: Handlers::DoNothing)
        else
          Good.build(item.sell_in, item.quality)
        end
      end
    end

    class Good
      def self.build(sell_in, quality)
        if expired?(sell_in)
          new(sell_in, quality, quality_handler: Handlers::Multiplier.new(2, Handlers::Quality::Substract))
        else
          new(sell_in, quality)
        end
      end

      def self.expired?(sell_in)
        sell_in <= 0
      end

      attr_reader :sell_in, :quality

      def initialize(sell_in, quality, sell_in_handler: Handlers::Substract,
                     quality_handler: Handlers::Quality::Substract)
        @sell_in = sell_in
        @quality = quality
        @sell_in_handler = sell_in_handler
        @quality_handler = quality_handler
      end

      def update!
        @sell_in = @sell_in_handler.execute(sell_in)
        @quality = @quality_handler.execute(quality)
      end
    end

    class Conjured < Good
      def self.build(sell_in, quality)
        if expired?(sell_in)
          new(sell_in, quality, quality_handler: Handlers::Multiplier.new(4, Handlers::Quality::Substract))
        else
          new(sell_in, quality, quality_handler: Handlers::Multiplier.new(2, Handlers::Quality::Substract))
        end
      end
    end

    class AgedBrie < Good
      def self.build(sell_in, quality)
        if expired?(sell_in)
          new(sell_in, quality, quality_handler: Handlers::Multiplier.new(2, Handlers::Quality::Add))
        else
          new(sell_in, quality, quality_handler: Handlers::Quality::Add)
        end
      end
    end

    class BackstagePass < Good
      def self.build(sell_in, quality)
        if expired?(sell_in)
          new(sell_in, quality, quality_handler: Handlers::Reset)
        elsif sell_in <= 5
          new(sell_in, quality, quality_handler: Handlers::Multiplier.new(3, Handlers::Quality::Add))
        elsif sell_in <= 10
          new(sell_in, quality, quality_handler: Handlers::Multiplier.new(2, Handlers::Quality::Add))
        else
          new(sell_in, quality, quality_handler: Handlers::Quality::Add)
        end
      end
    end
  end

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      good = Inventory::GoodsFactory.for(item)
      good.update!
      item.sell_in = good.sell_in
      item.quality = good.quality
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
