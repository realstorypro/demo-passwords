# frozen_string_literal: true

require 'json'
require 'digest'

require 'httparty'
require 'dotenv/load'

# require 'awesome_print'
# require 'byebug'

def lambda_handler(event:, context:)
  time = Time.now.utc

  start_date = Date.parse('1/1/2022')
  current_date = Date.parse(time.strftime("%d/%m/%Y"))

  password_seed = get_seed(start_date: start_date, end_date: current_date)

  users = []

  500.times do |i|
    username = "demo_user_5#{password_seed}#{i}"
    users.push({ username: username, password: Digest::SHA2.hexdigest("#{username}-#{password_seed}")[0..10] })
  end

  { statusCode: 200, body: users.sample.to_json }
end

def get_seed(start_date:, end_date:)
  days_passed = Integer(end_date - start_date)
  seed = days_passed / 30

  # we dont want the seed to be zero
  return 1 if seed.zero?

  # return seed + 1 since zero is 1
  seed + 1
end

# lambda_handler(event: 'hi', context: 'bye')
