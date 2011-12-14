require "rack"
require "rack/request"
require "uri"
require 'iconv'
require 'rchardet19'

module Rack
  class CharsetFilter
    
    attr_reader :logger

    def initialize(app, opts = {})
      @app = app
      @logger = opts[:logger]
    end
    
    def call(env)
      request = Request.new(env)
      query_string = request.query_string
      decoded_query_string = URI::decode(query_string)

      dc = CharDet.detect(decoded_query_string.dup)
      # log des charsets détectés (autres que utf-8)
      if logger && dc.encoding != 'utf-8'
        logger.info "[CharsetFilter] #{decoded_query_string} (#{dc.encoding})" 
        logger.info "[CharsetFilter] accept_encoding: #{request.accept_encoding}" 
        logger.info "[CharsetFilter] charset: (#{request.content_charset})" 
      end
      
      if ["windows-1252", "ISO-8859-2"].include?(dc.encoding) && dc.confidence > 0.6
        env["QUERY_STRING"] = URI.encode(Iconv.conv('UTF-8', 'windows-1252', decoded_query_string))
      end
      
      @app.call(env)
    end

    
  end
end