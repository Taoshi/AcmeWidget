# frozen_string_literal: true

module Strategies
  # Base class for offer strategies
  class OfferStrategy
    def apply(cart_items:, catalog:, subtotal:)
      raise NotImplementedError, "Subclasses must implement apply method"
    end
  end
end
