require_relative 'spec_helper'

describe "connection to Elsevier host" do
  before do
    if api_available?
      @conn=ElsevierApi::Connection.new(ENV['ELSEVIER_API_KEY'],
                                        proxy_host: ENV['PROXY_HOST'],

                                        proxy_port: ENV['PROXY_PORT'],
                                        proxy_user: ENV['PROXY_USER'],
                                        proxy_pass: ENV['PROXY_PASS']
                                        )
    end
  end
  it "should connect and retrieve a ElsevierApi::XMLResponse::Authorretrievalresponse for an author query" do
    unless api_available?
      skip("SKIPPED BECAUSE NO KEY AVAILABLE")
    else

      result= @conn.retrieve_response("https://api.elsevier.com/content/author?author_id=56609918400&view=LIGHT")
      expect(@conn.error).to be_falsey
      expect(result).to be_instance_of(ElsevierApi::XMLResponse::Authorretrievalresponse)
    end

  end

  it "should connect and retrieve a ElsevierApi::XMLResponse::Searchresults for a search query" do
    unless api_available?
      skip("SKIPPED BECAUSE NO KEY AVAILABLE")
    else
      uri=@conn.get_uri_articles_country_year_area("Chile","2019","PSYC")
      result= @conn.retrieve_response("#{uri}&count=1")
      expect(@conn.error).to be_falsey
      expect(result).to be_instance_of(ElsevierApi::XMLResponse::Searchresults)
      expect(result.entries_to_ary).to be_instance_of(Array)
    end

  end

  it "if wrong, should return a nil value" do
    unless api_available?
    skip("SKIPPED BECAUSE NO KEY AVAILABLE")
    else
      result= @conn.retrieve_response("https://api.elsevier.com/content/asdasdasdsada")
      expect(@conn.error).to be_truthy
      expect(result).to be_nil
    end

  end

  after do
    if api_available?
      @conn.close
    end
  end
end
