
require 'spec_helper'

describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end
  end

  describe 'texttest_fixture' do
    it 'should return the correct output' do
      report_lines = ''
      items = [
        Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20),
        Item.new(name="Aged Brie", sell_in=2, quality=0),
        Item.new(name="Elixir of the Mongoose", sell_in=5, quality=7),
        Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80),
        Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=80),
        Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20),
        Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=49),
        Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=49),
        # This Conjured item does not work properly yet
        Item.new(name="Conjured Mana Cake", sell_in=3, quality=6), # <-- :O
      ]

      days = 11

      gilded_rose = GildedRose.new items
      (0...days).each do |day|
        report_lines << "-------- day #{day} --------\n"
        report_lines << "name, sellIn, quality\n"
        items.each do |item|
          report_lines << item.to_s
          report_lines << "\n"

        end
        report_lines << "\n"
        gilded_rose.update_quality
      end

      expected_output = <<~eos
        -------- day 0 --------
        name, sellIn, quality
        +5 Dexterity Vest, 10, 20
        Aged Brie, 2, 0
        Elixir of the Mongoose, 5, 7
        Sulfuras, Hand of Ragnaros, 0, 80
        Sulfuras, Hand of Ragnaros, -1, 80
        Backstage passes to a TAFKAL80ETC concert, 15, 20
        Backstage passes to a TAFKAL80ETC concert, 10, 49
        Backstage passes to a TAFKAL80ETC concert, 5, 49
        Conjured Mana Cake, 3, 6

        -------- day 1 --------
        name, sellIn, quality
        +5 Dexterity Vest, 9, 19
        Aged Brie, 1, 1
        Elixir of the Mongoose, 4, 6
        Sulfuras, Hand of Ragnaros, 0, 80
        Sulfuras, Hand of Ragnaros, -1, 80
        Backstage passes to a TAFKAL80ETC concert, 14, 21
        Backstage passes to a TAFKAL80ETC concert, 9, 50
        Backstage passes to a TAFKAL80ETC concert, 4, 50
        Conjured Mana Cake, 2, 5

        -------- day 2 --------
        name, sellIn, quality
        +5 Dexterity Vest, 8, 18
        Aged Brie, 0, 2
        Elixir of the Mongoose, 3, 5
        Sulfuras, Hand of Ragnaros, 0, 80
        Sulfuras, Hand of Ragnaros, -1, 80
        Backstage passes to a TAFKAL80ETC concert, 13, 22
        Backstage passes to a TAFKAL80ETC concert, 8, 50
        Backstage passes to a TAFKAL80ETC concert, 3, 50
        Conjured Mana Cake, 1, 4

        -------- day 3 --------
        name, sellIn, quality
        +5 Dexterity Vest, 7, 17
        Aged Brie, -1, 4
        Elixir of the Mongoose, 2, 4
        Sulfuras, Hand of Ragnaros, 0, 80
        Sulfuras, Hand of Ragnaros, -1, 80
        Backstage passes to a TAFKAL80ETC concert, 12, 23
        Backstage passes to a TAFKAL80ETC concert, 7, 50
        Backstage passes to a TAFKAL80ETC concert, 2, 50
        Conjured Mana Cake, 0, 3

        -------- day 4 --------
        name, sellIn, quality
        +5 Dexterity Vest, 6, 16
        Aged Brie, -2, 6
        Elixir of the Mongoose, 1, 3
        Sulfuras, Hand of Ragnaros, 0, 80
        Sulfuras, Hand of Ragnaros, -1, 80
        Backstage passes to a TAFKAL80ETC concert, 11, 24
        Backstage passes to a TAFKAL80ETC concert, 6, 50
        Backstage passes to a TAFKAL80ETC concert, 1, 50
        Conjured Mana Cake, -1, 1

        -------- day 5 --------
        name, sellIn, quality
        +5 Dexterity Vest, 5, 15
        Aged Brie, -3, 8
        Elixir of the Mongoose, 0, 2
        Sulfuras, Hand of Ragnaros, 0, 80
        Sulfuras, Hand of Ragnaros, -1, 80
        Backstage passes to a TAFKAL80ETC concert, 10, 25
        Backstage passes to a TAFKAL80ETC concert, 5, 50
        Backstage passes to a TAFKAL80ETC concert, 0, 50
        Conjured Mana Cake, -2, 0

        -------- day 6 --------
        name, sellIn, quality
        +5 Dexterity Vest, 4, 14
        Aged Brie, -4, 10
        Elixir of the Mongoose, -1, 0
        Sulfuras, Hand of Ragnaros, 0, 80
        Sulfuras, Hand of Ragnaros, -1, 80
        Backstage passes to a TAFKAL80ETC concert, 9, 27
        Backstage passes to a TAFKAL80ETC concert, 4, 50
        Backstage passes to a TAFKAL80ETC concert, -1, 0
        Conjured Mana Cake, -3, 0

        -------- day 7 --------
        name, sellIn, quality
        +5 Dexterity Vest, 3, 13
        Aged Brie, -5, 12
        Elixir of the Mongoose, -2, 0
        Sulfuras, Hand of Ragnaros, 0, 80
        Sulfuras, Hand of Ragnaros, -1, 80
        Backstage passes to a TAFKAL80ETC concert, 8, 29
        Backstage passes to a TAFKAL80ETC concert, 3, 50
        Backstage passes to a TAFKAL80ETC concert, -2, 0
        Conjured Mana Cake, -4, 0

        -------- day 8 --------
        name, sellIn, quality
        +5 Dexterity Vest, 2, 12
        Aged Brie, -6, 14
        Elixir of the Mongoose, -3, 0
        Sulfuras, Hand of Ragnaros, 0, 80
        Sulfuras, Hand of Ragnaros, -1, 80
        Backstage passes to a TAFKAL80ETC concert, 7, 31
        Backstage passes to a TAFKAL80ETC concert, 2, 50
        Backstage passes to a TAFKAL80ETC concert, -3, 0
        Conjured Mana Cake, -5, 0

        -------- day 9 --------
        name, sellIn, quality
        +5 Dexterity Vest, 1, 11
        Aged Brie, -7, 16
        Elixir of the Mongoose, -4, 0
        Sulfuras, Hand of Ragnaros, 0, 80
        Sulfuras, Hand of Ragnaros, -1, 80
        Backstage passes to a TAFKAL80ETC concert, 6, 33
        Backstage passes to a TAFKAL80ETC concert, 1, 50
        Backstage passes to a TAFKAL80ETC concert, -4, 0
        Conjured Mana Cake, -6, 0

        -------- day 10 --------
        name, sellIn, quality
        +5 Dexterity Vest, 0, 10
        Aged Brie, -8, 18
        Elixir of the Mongoose, -5, 0
        Sulfuras, Hand of Ragnaros, 0, 80
        Sulfuras, Hand of Ragnaros, -1, 80
        Backstage passes to a TAFKAL80ETC concert, 5, 35
        Backstage passes to a TAFKAL80ETC concert, 0, 50
        Backstage passes to a TAFKAL80ETC concert, -5, 0
        Conjured Mana Cake, -7, 0

      eos
      expect(report_lines).to eq expected_output
    end
  end
end
