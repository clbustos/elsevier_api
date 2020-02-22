require_relative 'spec_helper'
require 'tempfile'
describe "ElsevierApi module methods" do
  before {

    @fixture_dir=File.join(File.dirname(__FILE__),"fixtures")

  }
  it "process_xml should retrieve a proper XMLRequest object" do

    expect(ElsevierApi.process_xml(File.read(File.join(@fixture_dir, "search_2.xml")))).to be_instance_of(ElsevierApi::XMLResponse::Searchresults)

    expect(ElsevierApi.process_xml(File.read(File.join(@fixture_dir, "abstractCitationResp.xml")))).to be_instance_of(ElsevierApi::XMLResponse::Abstractcitationsresponse)

    expect(ElsevierApi.process_xml(File.read(File.join(@fixture_dir, "AUTHOR_2.xml")))).to be_instance_of(ElsevierApi::XMLResponse::Authorretrievalresponselist)
  end
  it "entries_to_csv retrieve a proper CSV" do
    xml = ElsevierApi.process_xml(File.read(File.join(@fixture_dir, "search_2.xml")))
    csv_temp=Tempfile.new("test_csv")
    ElsevierApi.entries_to_csv(xml.entries_to_ary,csv_temp.path)
    resultado=File.read(csv_temp.path)
    expect(resultado).to include("Six conversational practices")
    csv_temp.close
  end
end