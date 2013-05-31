require 'curb'
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

      def during_year(year)
        hash = get_hash(EQS_URI + "/#{year}")
        hash["earthquakes"].collect do |q|
          Earthquake.new(q["src"], q["eqid"], q["timedate"], q["lat"],
                         q["lon"], q["magnitude"], q["depth"], q["region"])
        end
      end

      def during_month(year, month)
        hash = get_hash(EQS_URI + "/#{year}/#{month}")
        hash["earthquakes"].collect do |q|
          Earthquake.new(q["src"], q["eqid"], q["timedate"], q["lat"],
                         q["lon"], q["magnitude"], q["depth"], q["region"])
        end
      end

      def monthly_total(year, month)
        totals = get_hash(TOTALS_URI)
        total = totals["#{year}.#{month}"].to_i
      end

      def yearly_total(year)
        totals = get_hash(TOTALS_URI)
        total = totals["#{year}"].to_i
      end
    end

    class Earthquake < Struct.new(:src, :eqid, :timedate, :lat, :lon, 
                                  :magnitude, :depth, :region)
    end

  end
end
