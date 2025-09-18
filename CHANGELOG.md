# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- Stop raising on API HTTP errors (4xx/5xx)

## [0.2.0] - 2024-12-19

### Added
- Support for multiple FrontPayment API environments (production and demo)
- New `demo` parameter in Client initialization to easily switch between environments
- Documentation for Client initialization parameters

### Changed
- **BREAKING**: Client initialization now requires named parameters - `Frontgo::Client.new(key: 'your-key')` instead of positional arguments
- **BREAKING**: API methods now return the full Faraday response object instead of just the response body, allowing access to status codes and headers
- Default environment is now production (`https://apigo.frontpayment.no/api/v1`)
- Demo environment available at `https://demo-api.frontpayment.no/api/v1/` when `demo: true` is passed

## [0.1.1] - 2024-12-19

### Added
- Test coverage for `Order.get_order_status_by_uuid` method

### Fixed
- All Standard Ruby style guide violations
- Class naming conventions - renamed to singular form for better Ruby conventions

## [0.1.0] - 2024-12-19

### Added
- Initial release of the Frontgo gem
- Full support for FrontPayment API endpoints:
  - **Orders**: Create payment sessions, get order status
  - **Customers**: Manage customer records
  - **Subscriptions**: Handle recurring payments
  - **Refunds**: Process refunds
  - **Reservations**: Manage payment reservations
  - **Terminal**: Terminal payment operations
  - **Credit**: Credit-related operations
