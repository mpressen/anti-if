class GildedRose

  def initialize(items)
    @items = items
  end

  def increase_quality(item)
    item.quality += 1 if item.quality < 50
  end

  def degrade_quality(item)
    item.quality -= 1 if item.quality > 0
  end

  def update_quality()
    @items.each do |item|
      if item.name == "Aged Brie"
        item.sell_in -= 1
        increase_quality(item)
        if item.sell_in < 0
          increase_quality(item)
        end
      elsif item.name == "Backstage passes to a TAFKAL80ETC concert"
        item.sell_in -= 1
        increase_quality(item)
        if item.sell_in < 10
          increase_quality(item)
        end
        if item.sell_in < 5
          increase_quality(item)
        end
        if item.sell_in < 0
          item.quality = 0
        end
      elsif item.name == "Sulfuras, Hand of Ragnaros"
      else
        item.sell_in -= 1
        degrade_quality(item)
        if item.sell_in < 0
          degrade_quality(item)
        end
      end
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
