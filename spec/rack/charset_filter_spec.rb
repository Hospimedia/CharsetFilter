# encoding: utf-8

require 'rack/request'
require 'rack/mock'
require "rack/charset_filter"

describe Rack::CharsetFilter do
  
  def request
    @request
  end

  def response_env(status = 200)
    [status, {"Content-type" => "test/plain", "Content-length" => "5"}, ["hello"]]
  end
  
  def app
    @app ||= lambda do |env|
      @request = Rack::Request.new(env)
      response_env
    end
  end
  
  subject { Rack::CharsetFilter.new(app) }
  
  it "should return a 200 response" do
    request = Rack::MockRequest.new(subject)
    response = request.get("/", { "QUERY_STRING" => "a=1&b=2" })
    
    response.status.should eq(200)
  end
  
  context "if there's a query string" do
    
    before(:each) do
      @request = Rack::MockRequest.new(subject)
    end
    
    context "that is correctly encoded" do
      it "should not remove it from the response" do
        app.should_receive(:call).with(hash_including({ "QUERY_STRING" => "a=1&b=2" })).and_return(response_env)

        response = request.get("/", { "QUERY_STRING" => "a=1&b=2" })
      end
      
      it "should not try to convert it" do
        app.should_receive(:call).with(hash_including({ "QUERY_STRING" => "a=1&b=%C3%8Ele" })).and_return(response_env)
        
        response = request.get("/", { "QUERY_STRING" => "a=1&b=%C3%8Ele" })
      end
    end
    
    context "and if its params are not UTF-8 encoded" do
      it "should convert the query params to UTF-8" do
        app.should_receive(:call).with(hash_including({ "QUERY_STRING" => "a=1&b=%C3%8Ele" })).and_return(response_env)
        
        response = request.get("/", { "QUERY_STRING" => "a=1&b=%CEle" })
      end
    end
  end
end