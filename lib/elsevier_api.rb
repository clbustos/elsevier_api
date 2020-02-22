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

require 'nokogiri'
# Module ElsevierApi
#
# Provides access to ElsevierApi dev services
module ElsevierApi
    # Factory method
    def self.process_xml(xml)

      xml=Nokogiri::XML(xml) if xml.is_a? String
      if xml.children.length==0
        # Error
        ElsevierApi::XMLResponse::XMLEmpty.new
      else
        name=xml.children[0].name.gsub("-","").capitalize
        ElsevierApi::XMLResponse.const_get(name.to_sym).new(xml)
      end

    end
    
    def self.entries_to_csv(entries,csv_file)
      require 'csv'
      d=Date.today.to_s      
      header=["scopus_id","title","journal","creator","doi","date"]
      CSV.open(csv_file,"wb") {|csv|
        csv << header
        entries.each {|e|
          csv << [e[:scopus_id],e[:title],e[:journal], e[:creator],e[:doi],d]
        }
      }
    end
    
end

require_relative "elsevier_api/uri_request"
require_relative "elsevier_api/connection"
require_relative "elsevier_api/xml_response"
  
  
