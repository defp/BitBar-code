#!/usr/bin/env ruby

require 'net/http'
require 'net/https'
require 'json'

# blackssl (GET )
def send_request(cookie)
  uri = URI('https://api.darkssl.com/v1/services/me/nodes')

  # Create client
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  # Create Request
  req = Net::HTTP::Get.new(uri)
  req.add_field 'Accept', '*/*'
  req.add_field 'Cookie', cookie
  req.add_field 'User-Agent', 'BlackSSL/257 CFNetwork/1125.2 Darwin/19.4.0 (x86_64)'
  req.add_field 'Accept-Language', 'en-us'
  req.add_field 'Accept-Encoding', 'gzip, deflate, br'
  req.add_field 'Connection', 'keep-alive'

  # Fetch Request
  res = http.request(req)
  res.body
rescue StandardError => e
  puts "HTTP Request failed (#{e.message})"
end

cookie = File.read("#{__dir__}/.blackssl.cookie")
body = send_request(cookie)
result = JSON.parse(body)

transfer_used_human = (result["transfer_used"].to_f / 1000 / 1000 / 1000).round(2)
puts "👨🏻‍💻已用#{transfer_used_human}GB"
puts "Refresh... | refresh=true"
puts "Dashboard Web | href=https://blackssl.com/dashboard"