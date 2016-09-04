$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'scopus'
require 'rspec'
module Helpers
  def load_arr(file)
    rev_xml=File.dirname(File.expand_path(__FILE__))+"/fixtures/#{file}"
    $xml=File.open(rev_xml) { |f|
      Nokogiri::XML(f)
    }
    Scopus.process_xml($xml)
  end

end


RSpec.configure do |c|
  c.include Helpers
end