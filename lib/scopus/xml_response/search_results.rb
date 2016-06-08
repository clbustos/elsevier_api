module Scopus
  module XMLResponse
    
    class Scopus::XMLResponse::Searchresults < XMLResponseGeneric
    def next_page
      @xml.at_xpath("//atom:link[@ref='next']")
    end
    def entries_to_hash
      @xml.xpath("//atom:entry").map {|v|
        h={
          :scopus_id=>v.at_xpath("dc:identifier").text,
          :title=>v.at_xpath("dc:title").text,
          :journal=>v.at_xpath("prism:publicationName").text
        }
        {:creator=>"dc:creator",:doi=>"prism:doi"}.each_pair {|key,xv|
          h[key]=v.at_xpath(xv).text unless v.at_xpath(xv).nil?
        }
        h
      }
    end    
    
  end
end

end