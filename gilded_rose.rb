class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      if sulfuras?(item)
      elsif generic?(item)
        if item.quality > 0
          if !sulfuras?(item)
            decrease_quality(item)
          end
        end
      else
        if quality_less_than_50(item)
          increase_quality(item)
          if backstage_pass?(item)
            if item.sell_in < 11
              if quality_less_than_50(item)
                increase_quality(item)
              end
            end
            if item.sell_in < 6
              if quality_less_than_50(item)
                increase_quality(item)
              end
            end
          end
        end
      end
      if !sulfuras?(item)
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if !aged_brie?(item)
          if !backstage_pass?(item)
            if item.quality > 0
              if !sulfuras?(item)
                decrease_quality(item)
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if quality_less_than_50(item)
            increase_quality(item)
          end
        end
      end
    end
  end

  private

  def decrease_quality(item)
    item.quality = item.quality - 1
  end

  def increase_quality(item)
    item.quality = item.quality + 1
  end

  def quality_less_than_50(item)
    item.quality < 50
  end

  def aged_brie?(item)
    item.name == "Aged Brie"
  end

  def backstage_pass?(item)
    item.name == "Backstage passes to a TAFKAL80ETC concert"
  end

  def sulfuras?(item)
    item.name == "Sulfuras, Hand of Ragnaros"
  end

  def generic?(item)
    !(aged_brie?(item) || backstage_pass?(item) || sulfuras?(item))
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
