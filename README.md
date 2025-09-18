# Frontgo

Thin Ruby client for [FrontPayment API](https://docs.frontpayment.no/).

## Installation

Add to your Gemfile:

```ruby
gem 'frontgo'
```

And then install
`bundle install`

## Usage

```ruby
client = Frontgo::Client.new(key: 'your-api-key') # add demo: true to make calls to non-production instance.

# Create payment session
client.create_session_for_one_time_payment_link({
  products: [{ name: "Product", rate: 1000, tax: 25, amount: 1250 }],
  orderSummary: { subTotal: 1000, totalTax: 250, grandTotal: 1250 },
  customerDetails: { name: "John Doe", email: "john@example.com" },
  submitPayment: { via: "visa", currency: "NOK" },
  callback: { success: "https://example.com/success", failure: "https://example.com/failure" }
})

# Get order status
client.get_order_status_by_uuid("ODR123456789")

# With all the recommended error handling
begin
  response = client.get_order_status_by_uuid("ODR123")
  if response.success?
    # handle success
  else
    # handle non-2xx response
  end
rescue Faraday::TimeoutError, Faraday::ConnectionFailed, Faraday::SSLError => e
  warn "Network error: #{e.class}: #{e.message}"
rescue Faraday::ParsingError => e
  warn "Parsing error: #{e.message}"
end
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skatkov/frontgo.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
