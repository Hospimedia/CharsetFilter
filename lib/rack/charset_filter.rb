require "rack"
require "rack/request"
require "uri"
require 'iconv'
require 'rchardet19'
require "logger"

module Rack
  class CharsetFilter
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      request = Request.new(env)
      query_string = request.query_string
      decoded_query_string = URI::decode(query_string)
      
      dc = CharDet.detect(decoded_query_string)
      # log des charsets détectés (autres que utf-8)
      logger.info "[CharsetFilter] #{decoded_query_string} (#{dc.encoding})" unless dc.encoding == 'utf-8'
      
      if ["windows-1252", "ISO-8859-2"].include?(dc.encoding) && dc.confidence > 0.6
        env["QUERY_STRING"] = URI.encode(Iconv.conv('UTF-8', 'windows-1252', decoded_query_string))
      end
      
      @app.call(env)
    end
    
    private
  
    def logger
      defined?(Rails.logger) ? Rails.logger : ::Logger.new($stderr)
    end
    
  end
end