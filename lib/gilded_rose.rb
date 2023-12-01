class GildedRose
  module Inventory
    class Good
      def self.for(item)
        case item.name
        when "Aged Brie"
          AgedBrie.build(item.sell_in, item.quality)
        when "Backstage passes to a TAFKAL80ETC concert"
          BackstagePass.build(item.sell_in, item.quality)
        when "Sulfuras, Hand of Ragnaros"
          Sulfuras.new(item.sell_in, item.quality)
        when "Conjured Mana Cake"
          Conjured.build(item.sell_in, item.quality)
        else
          build(item.sell_in, item.quality)
        end
      end

      def self.build(sell_in, quality)
        if sell_in <= 0
          self::Expired.new(sell_in, quality)
        else
          new(sell_in, quality)
        end
      end

      attr_reader :sell_in, :quality

      def initialize(sell_in, quality)
        @sell_in = sell_in
        @quality = quality
      end

      def update!
        decrease_sell_in!
        update_quality!
      end

      private

      def decrease_sell_in!
        @sell_in -= 1
      end

      def update_quality!
        degrade_quality!
      end

      class Expired < Good
        private def update_quality!
          2.times { degrade_quality! }
        end
      end

      MIN_QUALITY = 0
      MAX_QUALITY = 50

      def degrade_quality!
        @quality -= 1 if quality > MIN_QUALITY
      end

      def increase_quality!
        @quality += 1 if quality < MAX_QUALITY
      end
    end

    class Conjured < Good
      private def update_quality!
        2.times { degrade_quality! }
      end

      class Expired < Conjured
        private def update_quality!
          4.times { degrade_quality! }
        end
      end
    end

    class AgedBrie < Good
      private def update_quality!
        increase_quality!
      end

      class Expired < AgedBrie
        private def update_quality!
          2.times { increase_quality! }
        end
      end
    end

    class BackstagePass < Good
      def self.build(sell_in, quality)
        if sell_in <= 0
          Expired.new(sell_in, quality)
        elsif sell_in <= 5
          LessThan5Days.new(sell_in, quality)
        elsif sell_in <= 10
          LessThan10Days.new(sell_in, quality)
        else
          new(sell_in, quality)
        end
      end

      private def update_quality!
        increase_quality!
      end

      class LessThan10Days < BackstagePass
        private def update_quality!
          2.times { increase_quality! }
        end
      end

      class LessThan5Days < BackstagePass
        private def update_quality!
          3.times { increase_quality! }
        end
      end

      class Expired < BackstagePass
        private def update_quality!
          @quality = quality - quality
        end
      end
    end

    class Sulfuras < Good
      def update!
      end
    end

  end

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      good = Inventory::Good.for(item)
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

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
