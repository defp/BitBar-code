#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'net/https'
require 'json'
# coding builds (GET )
def send_request(token)
  uri = URI('https://cmcmus.coding.net/api/enterprise/cmcmus/workbench/builds?page=1&pageSize=10')

  # Create client
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  # Create Request
  req = Net::HTTP::Get.new(uri)
  # Add headers
  req.add_field 'Authorization', "token #{token}"

  # Fetch Request
  res = http.request(req)
  res.body
rescue StandardError => e
  puts "HTTP Request failed (#{e.message})"
end

def pretty_status_emoji(status)
  if status == 'SUCCEED'
    '✅'
  else
    '❌'
  end
end

def pretty_line(build)
  job = build['jobName']
  status = build['status']
  status_emoji = pretty_status_emoji(status)

  "#{status_emoji} #{build['cause']} #{job} #{build['number']}"
end

def pretty_first_line(build)
  status = build['status']
  status_emoji = pretty_status_emoji(status)

  "Build: #{status_emoji} #{build['number']}"
end

token = File.read("#{__dir__}/.coding.token")
body = send_request(token)
result = JSON.parse(body)

builds = result['data']['list']

puts pretty_first_line(builds.first)
puts '---'
puts builds.map { |build| pretty_line(build) }.join("\n")
puts '---'
puts 'Refresh... | refresh=true'
puts '---'
puts 'Dashboard Web | href=https://cmcmus.coding.net/user'
