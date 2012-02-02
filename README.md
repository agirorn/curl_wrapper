curl_wrapper as the name says is a wraper for the curl command.

## install
  gem install 'curl_wrapper'
  
## use

```ruby
  curl = CurlWrapper.new do |config|
    config.url 'rubygems.org'
  end
  puts curl.body
  
  curl = CurlWrapper.new(:autorun => false) do |config|
    config.ntlm
    config.user 'username/password'
    config.request 'POST'
    config.verbose
    config.url 'http://hard_to_automate.sharepoint.com/resource' 
  end
  
  curl.run
  puts curl.error
```