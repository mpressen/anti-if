class GildedRose
  module Inventory
    class Good
      module Quality
        MAX = 50
        MIN = 0

        def self.degrade(item)
          item.quality -= 1 if item.quality > MIN
        end

        def self.increase(item)
          item.quality += 1 if item.quality < MAX
        end
      end

      def self.for(item)
        case item.name
        when "Aged Brie"
          AgedBrie.build(item)
        when "Backstage passes to a TAFKAL80ETC concert"
          BackstagePass.build(item)
        when "Sulfuras, Hand of Ragnaros"
          Sulfuras.new
        when "Conjured Mana Cake"
          Conjured.build(item)
        else
          build(item)
        end
      end

      def self.build(item)
        if item.sell_in <= 0
          self::Expired.new(item)
        else
          new(item)
        end
      end

      def initialize(item)
        @item = item
      end

      def update!
        decrease_sell_in!
        update_quality!
      end

      private

      def decrease_sell_in!
        @item.sell_in -= 1
      end

      def update_quality!
        Quality.degrade(@item)
      end

      class Expired < Good
        private def update_quality!
          2.times { Quality.degrade(@item) }
        end
      end
    end

    class Conjured < Good
      private def update_quality!
        2.times { Quality.degrade(@item) }
      end

      class Expired < Conjured
        private def update_quality!
          4.times { Quality.degrade(@item) }
        end
      end
    end

    class AgedBrie < Good
      private def update_quality!
        Quality.increase(@item)
      end

      class Expired < AgedBrie
        private def update_quality!
          2.times { Quality.increase(@item) }
        end
      end
    end

    class BackstagePass < Good
      def self.build(item)
        if item.sell_in <= 0
          Expired.new(item)
        elsif item.sell_in <= 5
          LessThan5Days.new(item)
        elsif item.sell_in <= 10
          LessThan10Days.new(item)
        else
          new(item)
        end
      end

      private def update_quality!
        Quality.increase(@item)
      end

      class LessThan10Days < BackstagePass
        private def update_quality!
          2.times { Quality.increase(@item) }
        end
      end

      class LessThan5Days < BackstagePass
        private def update_quality!
          3.times { Quality.increase(@item) }
        end
      end

      class Expired < BackstagePass
        private def update_quality!
          @item.quality = 0
        end
      end
    end

    class Sulfuras
      def update!
      end
    end

  end

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      Inventory::Good.for(item).update!
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
