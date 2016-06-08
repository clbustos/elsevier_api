module Scopus
  module XMLResponse
    class Abstractsretrievalresponse < XMLResponseGeneric
      attr_reader :scopus_id
      attr_reader :title
      attr_reader :type
      attr_reader :year
      attr_reader :journal
      attr_reader :authors
      attr_reader :volume
      attr_reader :issue
      attr_reader :starting_page
      attr_reader :ending_page
      attr_reader :doi
      attr_reader :affiliations
      attr_reader :abstract
      def inspect
        "#<#{self.class}:#{self.object_id} @title=#{@title} @journal=#{@journal} @authors=[#{@authors.keys.join(",")}]>"
      end
      
      def process_path(x,path)
        node=x.at_xpath(path)
        (node.nil?) ? nil : node.text
      end
      # We can't find the affiliation the ussual way
      # we have to improvise
      def search_affiliation(afid)
        x=xml.at_xpath("//affiliation[@afid=\"#{afid}\"]")
        if(!x)
          raise "I can't find affiliation #{afid}"
        else
          name=x.xpath("organization").map{|e| e.text}.join(";")
          country=x.attribute("country").value
        end
        {:name=>name, :city=>nil, :country=>country}
      end
      def process
        @scopus_id=process_path(xml,"//dc:identifier")
        @title=process_path(xml,"//dc:title")
        @type=process_path(xml,"//xmlns:srctype")
        @journal=process_path(xml,"//prism:publicationName")
        @volume=process_path(xml,"//prism:volume")
        @issue=process_path(xml,"//prism:issueIdentifier")
        @starting_page=process_path(xml,"//prism:startingPage")
        @ending_page=process_path(xml,"//prism:endingPage")
        @year=process_path(xml,"//year")
        @abstract=process_path(xml,"//dc:description/xmlns:abstract[@xml:lang='eng']/ce:para")
        #p @abstract
        @authors={}
        @affiliations={}
        
        xml.xpath("/xmlns:abstracts-retrieval-response/xmlns:affiliation").each do |x|
          id=x.attribute("id").value
          name=process_path(x,"xmlns:affilname")
          city=process_path(x,"xmlns:affiliation-city")
          country=process_path(x,"xmlns:affiliation-country")
          @affiliations[id]={
            :name     =>name,
            :city     =>city,
            :country  =>country
            
          }
        end
        
        xml.xpath("//xmlns:authors/xmlns:author").each do |x|
          
          auid=x.attribute("auid").value
          seq=x.attribute("seq").value
          initials  =process_path(x,"xmlns:preferred-name/ce:initials")
          indexed_name  = process_path(x,"xmlns:preferred-name/ce:indexed-name")
          given_name  =process_path(x,"xmlns:preferred-name/ce:given-name")
          surname=process_path(x,"xmlns:preferred-name/ce:surname")
          affiliation=nil
          affiliation_node=x.at_xpath("xmlns:affiliation")
          affiliation=affiliation_node.attribute("id").text unless affiliation_node.nil?
          if !affiliation.nil? and @affiliations[affiliation].nil?
            @affiliations[affiliation]=search_affiliation(affiliation)
          end
          #p "#{nombre} #{apellido}"
          @authors[auid]={
          :auid=>auid,
          :seq=>seq,
          :initials=>initials,
          :indexed_name=>indexed_name,
          :given_name=>given_name,
          :surname=>surname,
          :email=>nil,
          :affiliation=>affiliation
      }
      
      
      end
      # Searching for authors e-mails
      
      xml.xpath("//bibrecord//head//author-group/author//ce:e-address[@type='email']").each  do |email|
        auid=email.parent.attribute("auid").value
        @authors[auid][:email]=email.text
      end
      end
    end
  end
end