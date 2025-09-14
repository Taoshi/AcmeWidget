# frozen_string_literal: true

module Services
  # Calculates shipping costs based on cart total
  class ShippingService
    def initialize(rules:)
      @rules = rules
    end

    def cost(total)
      case total
      when 0...50  then @rules[:under_50]
      when 50...90 then @rules[:under_90]
      else              0.0
      end
    end
  end
end