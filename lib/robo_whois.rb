#--
# RoboWhois
#
# Ruby client for the RoboWhois API.
#
# Copyright (c) 2012 RoboDomain Inc.
#++


require 'robo_whois/version'
require 'httparty'


class RoboWhois
  include HTTParty

  class Error < StandardError
  end

  class APIError < Error
    # @return [Hash] The :key => "value" hash of attributes.
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
      super(attributes[:name])
    end
  end


  base_uri "http://api.robowhois.com"

  # @return [HTTParty::Response] The response object returned by the last API call.
  attr_reader :last_response


  def initialize(options = {})
    options[:api_key] = (options[:api_key] || ENV["ROBOWHOIS_API_KEY"]).to_s

    raise ArgumentError, "Missing API key" if options[:api_key].empty?

    @auth = { :username => options[:api_key], :password => "X" }
  end

  # Gets the current API key.
  #
  # @return [String]
  def api_key
    @auth[:username]
  end


  def account
    get("/account")["account"]
  end

  def whois(query)
    get("/whois/#{query}")
  end

  def whois_availability(query)
    get("/whois/#{query}/availability")["response"]
  end

  def whois_parts(query)
    get("/whois/#{query}/parts")["response"]
  end

  def whois_properties(query)
    get("/whois/#{query}/properties")["response"]
  end

  def whois_record(query)
    get("/whois/#{query}/record")["response"]
  end


private

  def get(path, params = {})
    request(:get, path, options(:query => params))
  end

  def request(method, path, options)
    @last_response = self.class.send(method, path, options)
    case @last_response.code
    when 200
      @last_response
    else
      error = @last_response["error"]
      raise APIError, { :code => error["code"], :name => error["name"], :status => @last_response.code }
    end
  end

  def options(hash = {})
    hash[:headers] ||= {}
    hash[:headers]["User-Agent"] = "RoboWhois Ruby #{VERSION}"
    hash[:basic_auth] = @auth
    hash
  end

end
