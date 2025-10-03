# frozen_string_literal: true

require_relative "models/product"
require_relative "services/shipping_service"
require_relative "strategies/offer_strategy"
require "bigdecimal"
require "bigdecimal/util"

# Main cart class that manages shopping cart functionality
class Cart
  attr_reader :items, :catalog, :shipping_cost, :offers

  def initialize(catalog:, shipping_cost:, offers: [])
    @catalog = catalog
    @shipping_cost = shipping_cost
    @offers = offers
    @items = []
  end

  def add(code)
    catalog.price(code)
    items << code
  end

  def total
    return 0.to_d if items.empty?

    subtotal = items.map { |code| catalog.price(code).to_d }.sum
    discounted = apply_offers(subtotal)
    shipping_cost_amount = shipping_cost.cost(discounted).to_d
    total_amount = discounted + shipping_cost_amount
    (total_amount * 100).floor / 100.to_d
  end

  private

  def apply_offers(subtotal)
    return subtotal if offers.empty?

    offers.reduce(subtotal) do |current, offer|
      offer.apply(cart_items: items, catalog: catalog, subtotal: current)
    end
  end
end
