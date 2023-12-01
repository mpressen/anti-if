require 'spec_helper'

describe GildedRose do
  # bundle exec mutant run --require ./lib/gilded_rose.rb --integration rspec -- 'GildedRose*'

  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq 'foo'
    end

    context 'when the item is Aged Brie' do
      it 'increases the quality the older it gets' do
        items = [Item.new('Aged Brie', 1, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 1
      end

      it 'increases the quality by 2 after the sell_in date' do
        items = [Item.new('Aged Brie', 0, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 2
      end
    end

    context 'when the item is Backstage passes' do
      it 'increases the quality by 1 when sell_in is more than 10' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 11, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 11
      end

      it 'increases the quality by 2 when sell_in is 10 or less' do
        items = [
          Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 10),
          Item.new('Backstage passes to a TAFKAL80ETC concert', 6, 8)
        ]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 12
        expect(items[1].quality).to eq 10
      end

      it 'increases the quality by 3 when sell_in is 5 or less' do
        items = [
          Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 10),
          Item.new('Backstage passes to a TAFKAL80ETC concert', 1, 7)
        ]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 13
        expect(items[1].quality).to eq 10
      end

      it 'drops the quality to 0 after the concert' do
        items = [
          Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 10),
          Item.new('Backstage passes to a TAFKAL80ETC concert', -1, 10)
        ]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
        expect(items[1].quality).to eq 0
      end

      it 'does not increase the quality above 50' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 50)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 50
      end
    end

    context 'when the item is Sulfuras' do
      it 'does not change the quality' do
        items = [Item.new('Sulfuras, Hand of Ragnaros', 0, 80)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 80
      end

      it 'does not change the sell_in' do
        items = [Item.new('Sulfuras, Hand of Ragnaros', 0, 80)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 0
      end
    end

    context 'when the item is Conjured' do
      it 'degrades in Quality twice as fast as normal items' do
        items = [Item.new('Conjured Mana Cake', 3, 6)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 4
      end

      it 'degrades in Quality twice as fast as normal items even after the sell_in date' do
        items = [Item.new('Conjured Mana Cake', 0, 6)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 2
      end

      it 'degrades in Quality four times as fast as normal items after the sell_in date' do
        items = [Item.new('Conjured Mana Cake', -1, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 6
      end

      it 'does not degrade quality below 0' do
        items = [Item.new('Conjured Mana Cake', 0, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end

      it 'degrades sell_in value by 1' do
        items = [Item.new('Conjured Mana Cake', 3, 6)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 2
      end
    end

    context 'when the item is anything else' do
      it 'degrades in Quality by 1 before the sell_in date' do
        items = [Item.new('Generic Item', 1, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 9
      end

      it 'degrades in Quality twice as fast after the sell_in date' do
        items = [Item.new('Generic Item', 0, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 8
      end

      it 'does not degrade quality below 0' do
        items = [Item.new('Generic Item', 0, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end

      it 'decreases sell_in value by 1 each day' do
        items = [Item.new('Generic Item', 10, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 9
      end
    end
  end
end
