require 'scraperwiki'
require 'mechanize'

info_url = 'https://eservices.southgippsland.vic.gov.au/ePathway/ePathProd/Web/GeneralEnquiry/EnquiryLists.aspx?ModuleCode=LAP'
comment_url = "mailto:council@southgippsland.vic.gov.au"

agent = Mechanize.new
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
page = agent.get(info_url)

# Click radio button 'Planning Application at Advertising'
form = page.form_with(:action => "./EnquiryLists.aspx?ModuleCode=LAP")
form["mDataGrid:Column0:Property"] = "ctl00$MainBodyContent$mDataList$ctl01$mDataGrid$ctl02$ctl00"
form["ctl00$MainBodyContent$mContinueButton"] = "Next"
page = form.submit

page.search("tr.ContentPanel, tr.AlternateContentPanel").each do |tr|
  record = {
    'council_reference' => tr.search("a")[0].inner_text,
    'address' => tr.search("span.ContentText, span.AlternateContentText")[0].inner_text.gsub('  ', ', '),
    'description' => tr.search("span.ContentText, span.AlternateContentText")[1].inner_text,
    'info_url' => info_url,
    'comment_url' => comment_url,
    'date_scraped' => Date.today.to_s,
    'date_received' => Date.parse(tr.search("span.ContentText, span.AlternateContentText")[2].inner_text).to_s,
  }

  puts "Storing " + record['council_reference'] + " - " + record['address']
#     puts record
  ScraperWiki.save_sqlite(['council_reference'], record)
end
