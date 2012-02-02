require 'curl_wrapper/version'
require 'curl_wrapper/config_options'
require 'open3'

class CurlWrapper
  include CurlWrapper::ConfigOptions
  
  class << self
    def method_missing(method, *args, &block)
      new.send(method, *args, &block)
    end
  end
  def initialize(&block)
    yield self if block_given?
  end
  
  def command
    ['curl', options].join(' ')
  end
  
  def run
    @stdin, @stdout, @stderr, @wait_thr = Open3.popen3(command)
  end
  
  def out
    run if @stdout.nil?
    @stdout.collect(&:to_s).join('')
  end
  alias :body :out
  alias :to_s :out
  
  def err
    run if @stdout.nil?
    @stderr.collect(&:to_s).join('')
  end
  
  def to_a
    [to_s]
  end
end

