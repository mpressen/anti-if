class GildedRose
  module Inventory
    class Quality
      attr_reader :amount

      def initialize(amount)
        @amount = amount
      end

      def degrade
        @amount -= 1 if amount > 0
      end

      def increase
        @amount += 1 if amount < 50
      end

      def reset
        @amount = 0
      end
    end

    class Generic
      def self.build(sell_in)
        if sell_in < 0
          Expired.new
        else
          new
        end
      end

      class Expired
        def update(quality)
          quality.degrade
          quality.degrade
        end
      end

      def update(quality)
        quality.degrade
      end
    end

    class Conjured
      def self.build(sell_in)
        if sell_in < 0
          Expired.new
        else
          new
        end
      end

      class Expired
        def update(quality)
          quality.degrade
          quality.degrade
          quality.degrade
          quality.degrade
        end
      end

      def update(quality)
        quality.degrade
        quality.degrade
      end
    end

    class AgedBrie
      def self.build(sell_in)
        if sell_in < 0
          Expired.new
        else
          new
        end
      end

      class Expired
        def update(quality)
          quality.increase
          quality.increase
        end
      end

      def update(quality)
        quality.increase
      end
    end

    class BackstagePass
      def self.build(sell_in)
        if sell_in < 0
          Expired.new
        elsif sell_in < 5
          LessThan5days.new
        elsif sell_in < 10
          LessThan10days.new
        else
          new
        end
      end

      class Expired
        def update(quality)
          quality.reset
        end
      end

      class LessThan5days
        def update(quality)
          quality.increase
          quality.increase
          quality.increase
        end
      end

      class LessThan10days
        def update(quality)
          quality.increase
          quality.increase
        end
      end

      def update(quality)
        quality.increase
      end
    end
  end

  class GoodCategory
    def build_for(item)
      case item.name
      when 'Aged Brie'
        Inventory::AgedBrie.build(item.sell_in)
      when 'Backstage passes to a TAFKAL80ETC concert'
        Inventory::BackstagePass.build(item.sell_in)
      when 'Conjured Mana Cake'
        Inventory::Conjured.build(item.sell_in)
      else
        Inventory::Generic.build(item.sell_in)
      end
    end
  end

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if sulfuras?(item)

      item.sell_in -= 1
      quality = Inventory::Quality.new(item.quality)
      good = GoodCategory.new.build_for(item)
      good.update(quality)
      item.quality = quality.amount
    end
  end

  private

  def sulfuras?(item)
    item.name == 'Sulfuras, Hand of Ragnaros'
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
