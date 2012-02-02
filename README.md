curl_wrapper as the name says is a wraper for the curl command.

## install ##
  gem install curl_wrapper
  
## use ##

```ruby
  curl = CurlWrapper.new do |config|
    config.url 'rubygems.org'
  end
  puts curl.body
```

```ruby
  curl = CurlWrapper.new do |config|
    config.ntlm
    config.user 'username/password'
    config.request 'POST'
    config.verbose
    config.url 'http://hard_to_automate.sharepoint.com/resource' 
  end
  
  curl.run
  puts curl.error
```

## CurlWrapper is chanable ##

```ruby
  puts CurlWrapper.new.url('rubygems.org').run.body
```

```ruby
  curl = CurlWrapper.new do |config|
    config.ntlm
    config.user 'username/password'
    config.request 'POST'
  end
  
  curl.verbose.url 'http://hard_to_automate.sharepoint.com/resource' 
  
  puts curl.run.error
```

## CurlWrapper is autoruns when you need the output ##

```ruby
  puts CurlWrapper.new.url('rubygems.org').body
```

```ruby
  curl = CurlWrapper.new do |config|
    config.ntlm
    config.user 'username/password'
    config.request 'POST'
  end
  
  curl.verbose.url 'http://hard_to_automate.sharepoint.com/resource' 
  
  puts curl.error
```

## CurlWrapper just works so you can have fun exploring HTTP ##
lets just skip new and body and stil get what we want
```ruby
  puts CurlWrapper.url('rubygems.org')
```

```ruby
  curl = CurlWrapper do |config|
    config.ntlm
    config.user 'username/password'
    config.request 'POST'
  end.verbose.url( 'http://hard_to_automate.sharepoint.com/resource' )
  
  puts curl
```
