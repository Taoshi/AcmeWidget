# frozen_string_literal: true

module Models
  # Product catalog that provides price lookup by code
  class Product
    def initialize(products)
      @products = products
    end

    def price(code)
      @products.fetch(code) { raise ArgumentError, "Unknown product #{code}" }
    end
  end
end
