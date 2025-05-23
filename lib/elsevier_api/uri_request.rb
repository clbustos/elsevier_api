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

require 'addressable/template'

module ElsevierApi
module URIRequest

    def get_uri_author(author_id,view=:light,opts={})
      if author_id.is_a? (Array)
        author_id=author_id.join(",")
      end

      opts={:author_id=>author_id, :view=>view.to_s.upcase}.merge(opts)

      template = Addressable::Template.new("https://api.elsevier.com/content/author{?query*}")
      template.expand({
                        "query" => opts
                      }).to_s

    end

    def get_uri_citation_overview(scopus_id,date,opts={})
      if scopus_id.is_a? (Array)
        scopus_id=scopus_id.join(",")
      end
      opts={:scopus_id=>scopus_id, :date=>date,:field=>"h-index,dc:identifier,scopus_id,pcc,cc,lcc,rangeCount,rowTotal,sort-year,prevColumnHeading,columnHeading,laterColumnHeading,prevColumnTotal,columnTotal,laterColumnTotal,rangeColumnTotal,grandTotal"}.merge(opts)
      template = Addressable::Template.new("https://api.elsevier.com/content/abstract/citations{?query*}")
      template.expand({
                        "query" => opts
                      }).to_s

    end

    def get_uri_articles_country_year_area(country,year,area)
      query="AFFILCOUNTRY ( #{country} )  AND  PUBYEAR  =  #{year}  AND  SUBJAREA ( \"#{area}\" )"

      opts={:sort=>'artnum', :query=>query}
      template = Addressable::Template.new("https://api.elsevier.com/content/search/scopus{?query*}")
      template.expand({
                        "query" => opts
                      }).to_s
    end
    # Get URI to obtain list of articles from a specific 
    # journal. You could specify year
    def get_uri_journal_articles(journal,year=nil)
      query="EXACTSRCTITLE(\"#{journal}\")"
      query+=" AND PUBYEAR IS #{year}" if year
      opts={:query=>query}
      template = Addressable::Template.new("https://api.elsevier.com/content/search/scopus{?query*}")

      template.expand({
                        "query" => opts
                      }).to_s

    end

    def get_uri_abstract(id,type="scopus_id",opts={:view=>"FULL"})
    raise "Type should be a string" unless type.is_a? String
    if opts[:view]
      opts_s="view=#{opts[:view]}"
    elsif opts[:field]
      opts_s="field=#{opts[:field]}"
    end

    template = Addressable::Template.new("https://api.elsevier.com/content/abstract/#{type}/#{id}{?query*}")

    template.expand({
                      "query" => opts_s
                    }).to_s

    end

  end
end
