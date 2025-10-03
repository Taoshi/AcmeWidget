# Acme Widget Co - Shopping Cart System

A Ruby implementation of a shopping cart system for Acme Widget Co with support for product catalog, shipping calculations, and special offers.

## Features

- **Product Management**: Support for Red, Green, and Blue widgets with configurable pricing
- **Shipping Calculation**: Tiered shipping costs based on cart total
- **Special Offers**: Extensible offer system with "buy one red widget, get the second half price" offer
- **Clean Architecture**: Separation of concerns with models, services, and strategies
- **Precision Handling**: Uses BigDecimal for accurate financial calculations

## Implementation Highlights

This project demonstrates several key Ruby development principles and patterns:

### ✅ Good Separation / Encapsulation of Concerns
- **Models**: `Product` class handles product catalog and price lookup
- **Services**: `ShippingService` encapsulates shipping cost calculation logic
- **Strategies**: `OfferStrategy` and implementations handle promotional offers
- **Main Class**: `Cart` orchestrates all functionality without mixing concerns

### ✅ Small Accurate Interfaces / Classes
- Each class has a single, well-defined responsibility
- `Product` - price lookup only
- `ShippingService` - shipping calculation only  
- `RedWidgetOfferStrategy` - specific offer implementation only
- `Cart` - cart management and total calculation

### ✅ Dependency Injection
- `Cart` accepts all dependencies through constructor injection
- `catalog`, `shipping_cost`, and `offers` are injected, not hardcoded
- Makes the system testable and flexible for different configurations

### ✅ Strategy Pattern / Extensible Code
- `OfferStrategy` base class defines the interface for all offers
- `RedWidgetOfferStrategy` implements the specific "buy one, get second half price" logic
- Easy to add new offer types without modifying existing code
- Follows Open/Closed Principle - open for extension, closed for modification

## Usage

```ruby
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
  shipping_calculator: shipping_service,
  offers: offers
)

# Add products
cart.add("R01")
cart.add("G01")

# Get total
total = cart.total
```

## Running Tests

```bash
# Run RSpec tests
rspec spec/

# Run example with test cases
ruby cart_example.rb
```

## Test Cases

The implementation passes all required test cases:

1. **B01, G01** → $37.85
2. **R01, R01** → $54.37  
3. **R01, G01** → $60.85
4. **B01, B01, R01, R01, R01** → $98.27