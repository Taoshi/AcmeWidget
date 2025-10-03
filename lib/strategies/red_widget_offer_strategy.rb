# frozen_string_literal: true

module Strategies
  # Buy one red widget, get the second half price
  class RedWidgetOfferStrategy < OfferStrategy
    RED_CODE = "R01"

    # Applies "buy one red widget, get the second half price" offer
    # @param cart_items [Array<String>] Array of product codes in the cart
    # @param catalog [Models::Product] Product catalog with prices
    # @param subtotal [BigDecimal] Current subtotal before discounts
    # @return [BigDecimal] Final subtotal after applying discount
    def apply(cart_items:, catalog:, subtotal:)
      count = cart_items.count(RED_CODE)
      discount_pairs = count / 2
      discount = discount_pairs * (catalog.price(RED_CODE) / 2.0)
      subtotal - discount
    end
  end
end
