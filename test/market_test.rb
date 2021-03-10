require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'
require './lib/market'
require './lib/vendor'
require 'pry'
require 'mocha/minitest'
require 'date'

class MarketTest < Minitest::Test
  def setup
    @market = Market.new("South Pearl Street Farmers Market")
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: "$0.50"})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")

    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
  end

  def test_it_exists
    assert_instance_of Market, @market
  end

  def test_it_has_attributes
    assert_equal "South Pearl Street Farmers Market", @market.name
  end

  def test_starts_with_no_vendors
    assert_equal [], @market.vendors
  end

  def test_add_vendor
    @market.add_vendor(@vendor1)
    assert_equal [@vendor1], @market.vendors

    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    assert_equal [@vendor1, @vendor2, @vendor3], @market.vendors
  end

  def test_vendor_names
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal ["Rocky Mountain Fresh",
                  "Ba-Nom-a-Nom",
                  "Palisade Peach Shack"
                 ], @market.vendor_names
  end

  def test_vendors_that_sell
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal [@vendor1, @vendor3], @market.vendors_that_sell(@item1)
  end

  def test_sorted_item_list
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal ["Banana Nice Cream",
                  'Peach',
                  "Peach-Raspberry Nice Cream",
                  'Tomato'], @market.sorted_item_list
  end

  def test_total_inventory
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    expected = {
                @item1 => {
                  quantity: 100,
                  vendors: [@vendor1, @vendor3]
                },
                @item2 => {
                  quantity: 7,
                  vendors: [@vendor1]
                },
                @item3 => {
                  quantity: 25,
                  vendors: [@vendor2]
                },
                @item4 => {
                  quantity: 50,
                  vendors: [@vendor2]
                },
    }
    assert_equal expected, @market.total_inventory
  end

  def test_overstocked_items
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal [@item1], @market.overstocked_items
  end

  def test_sell
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)

    assert_equal false, @market.sell(@item1, 200)
    assert_equal false, @market.sell(@item5, 1)
    assert_equal true, @market.sell(@item4, 5)

    assert_equal 45, @vendor2.check_stock(@item4)

    assert_equal true, @market.sell(@item1, 40)

    assert_equal 0, @vendor1.check_stock(@item1)
    assert_equal 60, @vendor3.check_stock(@item1)
  end

  def test_market_date
    market2 = Market.new("S Mart")
    market2.stubs(:date).returns("24/02/2020")

    assert_equal "24/02/2020", market2.date
  end
end
