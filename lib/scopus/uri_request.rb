
module Scopus
module URIRequest
  
    def get_uri_articles_country_year_area(country,year,area)
      query="AFFILCOUNTRY ( #{country} )  AND  PUBYEAR  =  #{year}  AND  SUBJAREA ( \"#{area}\" )"
      ::URI.encode("http://api.elsevier.com/content/search/scopus?apiKey=#{key}&query=#{query}")
    end
    # Get URI to obtain list of articles from a specific 
    # journal. You could specify year
    def get_uri_journal_articles(journal,year=nil)
    query="EXACTSRCTITLE(\"#{journal}\")"
    query+=" AND PUBYEAR IS #{year}" if year
    ::URI.encode("http://api.elsevier.com/content/search/scopus?apiKey=#{key}&query=#{query}")
    end
    def get_uri_abstract(id,type="scopus_id",opts={:view=>"FULL"})
    raise "Type should be a string" unless type.is_a? String
    if opts[:view]
      opts_s="view=#{opts[:view]}"
    elsif opts[:field]
      opts_s="field=#{opts[:field]}"
    end
    ::URI.encode("http://api.elsevier.com/content/abstract/#{type}/#{id}?apiKey=#{key}&#{opts_s}")
    end

  end
end