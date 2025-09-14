# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "frontgo"

require "minitest/autorun"

require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "test/vcr_cassettes"
  c.hook_into :faraday, :webmock

  c.default_cassette_options = {
    allow_unused_http_interactions: false
  }

  if !ENV["CI"].nil?
    c.default_cassette_options[:record] = :none
  end

  def client
    @client ||= Frontgo::Client.new(key: client_key, demo: true)
  end

  def client_key
    ENV["FRONTGO_API_KEY"] || "key"
  end

  # Filter out all Authorization headers
  c.filter_sensitive_data("<AUTH>") do |interaction|
    interaction.request.headers["Authorization"]&.first
  end
end
