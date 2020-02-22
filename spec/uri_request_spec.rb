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

    expect(uri).to eq("https://api.elsevier.com/content/abstract/citations?scopus_id=12345&date=2019&field=h-index,dc:identifier,scopus_id,pcc,cc,lcc,rangeCount,rowTotal,sort-year,prevColumnHeading,columnHeading,laterColumnHeading,prevColumnTotal,columnTotal,laterColumnTotal,rangeColumnTotal,grandTotal")
  end

  it "get get_uri_articles_country_year_area retrieves correct URI" do
    uri=@o.get_uri_articles_country_year_area("Chile","2019","PSYC")
    expect(uri).to eq("https://api.elsevier.com/content/search/scopus?sort=artnum&query=AFFILCOUNTRY%20(%20Chile%20)%20%20AND%20%20PUBYEAR%20%20=%20%202019%20%20AND%20%20SUBJAREA%20(%20%22PSYC%22%20)")
  end

end
