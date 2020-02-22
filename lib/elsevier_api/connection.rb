# Copyright (c) 2016-2020, Claudio Bustos Navarrete
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
require 'uri'
require 'net/http'
require 'curb'
module ElsevierApi
  class Connection
    extend  ElsevierApi::URIRequest
    include ElsevierApi::URIRequest
    attr_reader :key, :error, :error_msg, :xml_response, :raw_xml
    attr_accessor :use_proxy
    attr_accessor :proxy_host, :proxy_post, :proxy_user, :proxy_pass
  def initialize(key, opts={})
    @key=key
    @use_proxy=false
    @error=false
    @error_msg=nil
    if opts[:proxy_host]
      @use_proxy=true
      @proxy_host=opts[:proxy_host]
      @proxy_port=opts[:proxy_port]
      @proxy_user=opts[:proxy_user]
      @proxy_pass=opts[:proxy_pass]
    end
  end
  def connection
    @connection||=get_connection
  end
  def close
    @connection.close if @connection
  end

  # Connect to api and retrieve a response based on URI
  def retrieve_response(uri_string)
    @xml_response=nil
    begin
      Curl::Easy.new(uri_string) do |curl|
        if @use_proxy
          curl.proxy_tunnel = true
          curl.proxy_url = "http://#{@proxy_host}:#{@proxy_port}/"
          curl.proxypwd = "#{@proxy_user}:#{proxy_pass}"
        end
        curl.follow_location = true
        curl.ssl_verify_peer = false
        curl.max_redirects = 3
        curl.headers=['Accept: application/xml', "X-ELS-APIKey: #{@key}"]
        curl.perform
        #p curl.body_str
        xml=Nokogiri::XML(curl.body_str)
        if xml.xpath("//service-error").length>0
          @error=true
          @error_msg=xml.xpath("//statusText").text
        elsif xml.xpath("//atom:error",'atom'=>'http://www.w3.org/2005/Atom').length>0
          @error=true
          @error_msg=xml.xpath("//atom:error").text
        elsif xml.children.length==0
          @error=true
          @error_msg="Empty_XML"
        else
          @error=false
          @error_msg=nil
        end
        @xml_response=ElsevierApi.process_xml(xml)
      end
    rescue Exception=>e
      #$log.info(e.message)
      @error=true
      @error_msg=e.message
    end

    @xml_response
    
  end
  
  def get_articles_from_uri(uri)
    completo=false
    acumulado=[]
    pagina=1
    until completo do
      #puts "Page:#{pagina}"
      xml_response=retrieve_response(uri)
      if @error
        break
      else
        acumulado=acumulado+xml_response.entries_to_hash
        next_page=xml_response.next_page
        if next_page
          pagina+=1
          uri=next_page.attribute("href").value
        else
#          puts "completo"
          completo=true
        end
      end  
    end
    acumulado
  end
  
  def get_journal_articles(journal,year=nil)
    uri=get_uri_journal_articles(journal,year)
    completo=false
    acumulado=[]
    until completo do
      xml_response=retrieve_response(uri)
      if @error
        break
      else
        acumulado=acumulado+xml_response.entries_to_ary
        next_page=xml_response.next_page
        if next_page
          uri=next_page.attribute("href").value
          #puts "siguiente pagina"
        else
          #puts "completo"
          completo=true
        end
      end  
    end
    acumulado
    end  
  end
end
