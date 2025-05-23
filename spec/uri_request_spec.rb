require_relative 'spec_helper'

describe "URIRequest module" do
  before do
    @o=Object.new
    @o.extend ElsevierApi::URIRequest
  end
  it "get_uri_author retrieves correct URI" do
    uri=@o.get_uri_author(56609918400)
    expect(uri).to eq("https://api.elsevier.com/content/author?author_id=56609918400&view=LIGHT")
  end

  it "get_uri_citation_overview retrieves correct URI" do
    uri=@o.get_uri_citation_overview("12345","2019")
    expect(uri).to eq("https://api.elsevier.com/content/abstract/citations?scopus_id=12345&date=2019&field=h-index%2Cdc%3Aidentifier%2Cscopus_id%2Cpcc%2Ccc%2Clcc%2CrangeCount%2CrowTotal%2Csort-year%2CprevColumnHeading%2CcolumnHeading%2ClaterColumnHeading%2CprevColumnTotal%2CcolumnTotal%2ClaterColumnTotal%2CrangeColumnTotal%2CgrandTotal")
  end

  it "get get_uri_articles_country_year_area retrieves correct URI" do
    uri=@o.get_uri_articles_country_year_area("Chile","2019","PSYC")
    expect(uri).to eq("https://api.elsevier.com/content/search/scopus?sort=artnum&query=AFFILCOUNTRY%20%28%20Chile%20%29%20%20AND%20%20PUBYEAR%20%20%3D%20%202019%20%20AND%20%20SUBJAREA%20%28%20%22PSYC%22%20%29")
  end

end
