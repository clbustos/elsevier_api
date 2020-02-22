# elsevier-api

Provides access to Elsevier dev services for Ruby. You require an API from https://dev.elsevier.com/apikey/ first.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'elsevier-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elservier-api

## Usage

First, you should create a connection to Elsevier server using your Elsevier API key
```ruby
  require 'elsevier_api'
  @conn=ElsevierApi::Connection.new(api_key)
```

If you need to use a proxy, just add the information after the key.
```ruby
  @conn=ElsevierApi::Connection.new(api_key,
                                        proxy_host: proxy_host,

                                        proxy_port: proxy_port,
                                        proxy_user: proxy_user,
                                        proxy_pass: proxy_password
                                        ) 
```

The basic method is *retrieve_response*, that requires an URI and retrieves a parsed response. ElsevierApi retrieves the XML responde from Elsevier, and parse it using a class of type ElsevierApi::XMLResponse based on the first node of XML.

For example, we could retrieve the information about the developer of this gem

```ruby

info = @conn.retrieve_response("https://api.elsevier.com/content/author?author_id=56609918400")
info.class
=> ElsevierApi::XMLResponse::Authorretrievalresponse 
```

We could operate directly on the XML

```ruby
info.xml.xpath("//document-count").text
=> 26
```

A more interesting XMLResponse object is provided if we use a search

```ruby
query_encoded=URI::encode("(ruby language) and api")

search = @conn.retrieve_response("https://api.elsevier.com/content/search/scopus?query=#{query_encoded}&count=2")
search.class
=> ElsevierApi::XMLResponse::Searchresults

search.entries_to_ary
=> [{:scopus_id=>"SCOPUS_ID:85077509321",
  :title=>"Energy-Delay investigation of Remote Inter-Process communication technologies",
  :journal=>"Journal of Systems and Software",
  :creator=>"Georgiou S.",
  :doi=>"10.1016/j.jss.2019.110506"},
 {:scopus_id=>"SCOPUS_ID:85079458224",
  :title=>"A mechanized formalization of GraphQL",
  :journal=>
   "CPP 2020 - Proceedings of the 9th ACM SIGPLAN International Conference on Certified Programs and Proofs, co-located with POPL 2020",
  :creator=>"Diaz T.",
  :doi=>"10.1145/3372885.3373822"}]

```

The most complete parsing procedure was developed for abstracts, to retrieve complete information about authors and affiliations. 

```ruby
abstract = @conn.retrieve_response("https://api.elsevier.com/content/abstract/scopus_id/85079458224")
=> #<ElsevierApi::XMLResponse::Abstractsretrievalresponse:27496700 @title=A mechanized formalization of GraphQL @journal=CPP 2020 - Proceedings of the 9th ACM SIGPLAN International Conference on Certified Programs and Proofs, co-located with POPL 2020 @authors=[56940212100,35174987700,13104010300]>

abstract.scopus_id
=> "SCOPUS_ID:85079458224"

abstract.authors.first
=> ["56940212100",
 {:auid=>"56940212100",
  :seq=>"1",
  :initials=>"T.",
  :indexed_name=>"Diaz T.",
  :given_name=>"Tomas",
  :surname=>"Diaz",
  :email=>nil,
  :affiliation=>"123888358"}]

abstract.affiliations
=> {"60012464"=>
  {:id=>"60012464",
   :name=>"Universidad de Chile",
   :city=>"Santiago",
   :country=>"Chile",
   :type=>:scopus},
 "123888358"=>
  {:id=>"123888358", :name=>"IMFD Chile", :city=>"", :country=>"Chile", :type=>:scopus},
 "123888173"=>
  {:id=>"123888173",
   :name=>"U. of Chile and IMFD Chile and Inria Paris",
   :city=>"Paris",
   :country=>"France",
   :type=>:scopus}}
```

Some methods to create URIs for Elsevier API are located in ElsevierApi::URIRequest module, that is included on connection. 


## Development

After checking out the repository, use

    $ bundle install
    
to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/clbustos/elsevier-api.

