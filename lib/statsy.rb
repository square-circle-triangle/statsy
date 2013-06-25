require 'net/http'
require 'uri'
require 'json'

class Statsy
  VERSION = 0.1

  class NoAuthParams < StandardError
  end

  def initialize(api_key = nil, secret_key = nil)
    @api_key = api_key
    @secret_key = secret_key
  end

  def api_key=(api_key)
    @api_key = api_key
  end

  def api_key
    @api_key
  end

  def secret_key=(secret_key)
    @secret_key = secret_key
  end

  def secret_key
    @secret_key
  end

  # time, the amount of time in seconds you want this signature to be valid for
  # stream_prefix (optional), if set only allow streams
  def sign(expires, stream_prefix = nil)
    raise NoAuthParams if api_key.nil? || secret_key.nil?

    Digest::SHA1.base64digest([secret_key, 'POST', stream_prefix, expires].join(""))
  end

  def increment(stream, value = 1)
    send_data([{ stream: stream, weight: value }])
  end

  def send_data(streams)
    expires = Time.now.to_i + 600
    params = { api_key: api_key, expires: expires, signature: sign(expires), events: streams }

    net = Net::HTTP.new("statsyapp.com")
    request = Net::HTTP::Post.new("/api/v1/multiple_event")

    request.body = JSON.generate(params)
    request["Content-Type"] = "application/json"

    response = net.start do |http|
      http.request(request)
    end
  end
end
