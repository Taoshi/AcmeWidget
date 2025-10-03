require "rspec"
require_relative "../lib/cart"
require_relative "../lib/models/product"
require_relative "../lib/strategies/red_widget_offer_strategy"
require_relative "../lib/services/shipping_service"

RSpec.describe Cart do
  let(:catalog) do
    Models::Product.new({
      "R01" => 32.95,
      "G01" => 24.95,
      "B01" => 7.95
    })
  end

  let(:shipping_cost) do
    Services::ShippingService.new(rules: {
      under_50: 4.95,
      under_90: 2.95
    })
  end

  let(:offers) { [Strategies::RedWidgetOfferStrategy.new] }

  let(:cart) { Cart.new(catalog: catalog, shipping_cost: shipping_cost, offers: offers) }

  describe "#add" do
    it "adds a product to the cart" do
      cart.add("R01")
      expect(cart.items.length).to eq(1)
      expect(cart.items.first).to eq("R01")
    end

    it "increments quantity when adding the same product twice" do
      cart.add("R01")
      cart.add("R01")
      expect(cart.items.length).to eq(2)
      expect(cart.items.count("R01")).to eq(2)
    end

    it "raises error for invalid product code" do
      expect { cart.add("INVALID") }.to raise_error(ArgumentError, /Unknown product/)
    end
  end

  describe "#total" do
    it "calculates correct total for B01, G01" do
      cart.add("B01")
      cart.add("G01")
      expect(cart.total).to eq(BigDecimal("37.85"))

    end

    it "calculates correct total for R01, R01" do
      cart.add("R01")
      cart.add("R01")
      expect(cart.total).to eq(BigDecimal("54.37"))

    end

    it "calculates correct total for R01, G01" do
      cart.add("R01")
      cart.add("G01")
      expect(cart.total).to eq(BigDecimal("60.85"))
    end

    it "calculates correct total for B01, B01, R01, R01, R01" do
      cart.add("B01")
      cart.add("B01")
      cart.add("R01")
      cart.add("R01")
      cart.add("R01")
      expect(cart.total).to eq(BigDecimal("98.27"))
    end
  end
end
