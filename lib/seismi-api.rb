require 'curb'
require 'cgi'
require 'json'

module Seismi
  module API

    class Client
      BASE_API_URI = "http://www.seismi.org/api"
      TOTALS_URI = BASE_API_URI + "/totals"
      EQS_URI = BASE_API_URI + "/eqs"

      attr_reader :cache

      def initialize
        @cache = {}
      end

      def get_hash(uri)
        return @cache[uri] if @cache[uri]
        response = Curl.get(uri).body_str
        @cache[uri] = JSON.parse(response)
      end

      def where(options = {})
        hash = get_hash(EQS_URI)
        options.keys.each do |key, value|
          selected_quakes += hash.select { |quake| quake["key"] == value }
        end  
      end

      def during(options = {})
        # params = options.reject { |k| k != :limit && k != :min_magnitude }
        # uri = EQS_URI + to_query(params)
        if year = options[:year] && month = options[:month]
          hash = get_hash(EQS_URI + "/#{year}/#{month}")
        elsif year = options[:year]
          hash = get_hash(EQS_URI + "/#{year}")
        end 
        hash["earthquakes"].collect do |q|
          Earthquake.new(q["src"], q["eqid"], q["timedate"], q["lat"],
                         q["lon"], q["magnitude"], q["depth"], q["region"])
        end
      end

      def total(options = {})
        totals = get_hash(TOTALS_URI)
        if year = options[:year] && month = options[:month]
          total = totals["#{year}.#{month}"].to_i
        elsif year = options[:year]
          total = totals["#{year}"].to_i
        end
      end

      def to_query(params)
        "?" + params.map { |k ,v| "#{k}=#{CGI::escape v}" }.join("&")
      end
    end

    class Earthquake < Struct.new(:src, :eqid, :timedate, :lat, :lon, 
                                  :magnitude, :depth, :region)
    end

  end
end
