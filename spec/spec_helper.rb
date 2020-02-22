require 'simplecov'
unless ENV['NO_COVERAGE']
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require_relative '../lib/elsevier_api'

module ElsevierApiMixin
  def load_arr(file)
    rev_xml=File.dirname(File.expand_path(__FILE__))+"/fixtures/#{file}"
    xml=File.open(rev_xml) { |f|
      Nokogiri::XML(f)
    }
  ElsevierApi.process_xml(xml)
  end

  def api_available?
    !ENV['ELSEVIER_API_KEY'].nil?
  end

end


RSpec.configure { |c| c.include ElsevierApiMixin }
