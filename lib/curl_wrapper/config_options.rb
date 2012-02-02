require 'pp'
class CurlWrapper
  module ConfigOptions
    def method_missing(method, *args, &block)
      method = method.to_s
      if method.length == 1
        option = "-#{method}"
      else
        option = "--#{method.gsub('_', '-')}"
      end
      append_option option, args.first
    end
    
    def options
      @options
    end
    
    def append_option option, value = nil
      option = "#{option} '#{value}'" unless value.nil?
      if @options.nil?
        @options = option
      else
        @options = "#{@options} #{option}"
      end
      self
    end
    
    def fail
      append_option '--fail'
    end
    
    def http1_0
      append_option '--http1.0'
    end
    
    def proxy1_0 value
      append_option '--proxy1.0', value
    end
    
    def p
      append_option '-p'
    end
    
    def verbose
      append_option '--verbose'
    end
  end
end