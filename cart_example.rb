# frozen_string_literal: true

require_relative "lib/cart"
require_relative "lib/models/product"
require_relative "lib/services/shipping_service"
require_relative "lib/strategies/red_widget_offer_strategy"

# CLI for the Acme Widget Co cart system
class CartCLI
  def self.run(args = ARGV)
    if args.empty?
      p "Available products:"
      p "  R01 - Red Widget ($32.95)"
      p "  G01 - Green Widget ($24.95)"
      p "  B01 - Blue Widget ($7.95)"
      p " Use it like ruby example.rb PRODUCT_CODE Can add multiple for example (ruby example.rb R01 R01 R01)"
      return
    end

    # Initialize product catalog
    product_catalog = Models::Product.new({
      "R01" => 32.95,
      "G01" => 24.95,
      "B01" => 7.95
    })

    # Initialize shipping rules
    shipping_rules = {
      under_50: 4.95,
      under_90: 2.95
    }

    # Initialize shipping service
    shipping_service = Services::ShippingService.new(rules: shipping_rules)

    # Initialize offers
    offers = [Strategies::RedWidgetOfferStrategy.new]

    # Create cart
    cart = Cart.new(
      catalog: product_catalog,
      shipping_cost: shipping_service,
      offers: offers
    )

    # Add products from command line
    args.each do |product_code|
      begin
        cart.add(product_code)
        p "Added #{product_code} - $#{product_catalog.price(product_code)}"
      rescue ArgumentError => e
        p "Error: #{e.message}"
        p "Available products: R01, G01, B01"
        exit 1
      end
    end

    p "Cart contents: #{cart.items.join(", ")}"
    p "Total: $#{cart.total.to_f.round(2)}"
    
    p "Breakdown:"
    subtotal = cart.items.map { |code| product_catalog.price(code) }.sum
    p "  Subtotal: $#{subtotal.round(2)}"
    
    discounted_subtotal = cart.send(:apply_offers, subtotal.to_d).to_f
    
    discount = subtotal - discounted_subtotal
    
    if discount > 0
      p "Discount: -$#{discount.round(2)}"
    else
      p "  Discount: $0.00"
    end
    
    p "  After discount: $#{discounted_subtotal.round(2)}"
    p "  Shipping: $#{shipping_service.cost(discounted_subtotal).round(2)}"
    p "Final total: $#{cart.total.to_f.round(2)}"
  end
end

# Run if executed directly
CartCLI.run if __FILE__ == $0
