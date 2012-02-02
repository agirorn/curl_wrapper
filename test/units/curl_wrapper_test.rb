require 'minitest/autorun'
require 'minitest/pride'
require 'curl_wrapper'

class CurlWrapperTest < MiniTest::Unit::TestCase
  
  def test_curl_basic
    curl = CurlWrapper.new
    assert_equal 'curl ',  curl.command
  end
  
  def test_curl_with_block
    curl = CurlWrapper.new do |config|
      
    end
    assert_equal 'curl ',  curl.command
  end
  
  
end