class Vendor
  attr_reader :name,
              :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new
  end

  def check_stock(item)
    if @inventory[item].nil?
      return 0
    else
      @inventory[item]
    end
  end

  def stock(item, quantity)
    if @inventory[item].nil?
      @inventory[item] = quantity
    else
      @inventory[item] += quantity
    end
  end
end
