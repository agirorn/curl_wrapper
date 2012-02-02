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
  
  def test_collin_curl
    curl_result = `curl 2>/dev/null`
    curl = CurlWrapper.new
    curl.run
    assert_equal curl_result, curl.out, ":out should  return culr help message #{curl_result}"
  end
  
  def test_collin_curl
    curl_result = `curl 2>&1`
    curl = CurlWrapper.new
    curl.run
    assert_equal curl_result, curl.err, ":err should return culr help message #{curl_result}"
  end
  
  def test_command_after_help_option
    expected_command = 'curl --help'
    curl = CurlWrapper.new
    curl.help
     
    assert_equal expected_command, curl.command, ":command should be #{expected_command}"
  end
  
  def test_called_with_help_option
    expected_out = `curl --help`
    curl = CurlWrapper.new
    curl.help
    curl.run
    
    assert_equal expected_out, curl.out, ":out should return the help screen"
  end
  
  def test_excepts_config_in_a_block
    expected_out = `curl --help`
    curl = CurlWrapper.new do |config|
      config.help
    end
    curl.run
    
    assert_equal expected_out, curl.out, ":out should return the help screen"
  end
  
  def test_autoruns_on_calling_out
    expected_out = `curl --help`
    curl = CurlWrapper.new do |config|
      config.help
    end
    
    assert_equal expected_out, curl.out, ":out should return the help screen"
  end
  
  def test_autoruns_on_calling_err
    expected_out = ''
    curl = CurlWrapper.new do |config|
      config.help
    end
    
    assert_equal expected_out, curl.err, ":out should return the help screen"
  end
  
  def test_options_should_return_self
    expected_out = `curl --help`
    curl = CurlWrapper.new
    assert_equal curl, curl.help, "Should be returning it self"
  end
  
  def test_is_chanable
    expected_out = `curl --help`
    assert_equal expected_out, CurlWrapper.new.help.out, "Should be returning it self"
  end
  
  def test_get_new_out_of_the_way
    expected_out = `curl --help`
    assert_equal expected_out, CurlWrapper.help.out, "Should be returning it self"
  end
  
  def test_body_should_be_aliast_to_out
    expected_out = `curl --help`
    assert_equal expected_out, CurlWrapper.help.body, "Should be returning it self"
  end
  
  def test_to_s_should_be_aliast_to_out
    expected_out = `curl --help`
    assert_equal expected_out, CurlWrapper.help.to_s, "Should be returning it self"
  end
  
  def test_skiping_out_should_just_work
    expected_out = `curl --help`
    assert_equal expected_out, "#{CurlWrapper.help}", "Should be returning it self"
  end
  
  def test_should_convert_to_array_to_work_with_puts
    expected_out = `curl --help`
    assert_equal expected_out, CurlWrapper.help.to_ary.first, "Should be returning it self"
  end
  
  
end