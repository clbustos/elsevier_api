module Scopus
  module XMLResponse
    class XMLResponseGeneric
    attr_reader :xml
    def initialize(xml)
      @xml=xml
      process()
    end
    # Just put anything you want here
    def process
    end
    # XML should be a entries xml, from a search of article
    end
  end
end

require_relative "xml_response/abstract_retrieval_response"
require_relative "xml_response/search_results"
require_relative "xml_response/service_error"