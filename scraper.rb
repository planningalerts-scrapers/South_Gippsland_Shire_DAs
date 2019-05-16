require 'epathway_scraper'

info_url = 'https://eservices.southgippsland.vic.gov.au/ePathway/ePathProd/Web/GeneralEnquiry/EnquiryLists.aspx?ModuleCode=LAP'

scraper = EpathwayScraper::Scraper.new(
  base_url: info_url,
  index: 0
)

page = scraper.pick_type_of_search

scraper.extract_table_data_and_urls(page.at("table.ContentPanel")).each do |row|
  record = {
    'council_reference' => row[:content]["Application number"],
    'address' => row[:content]["Property Address"],
    'description' => row[:content]["Application Proposal"],
    'info_url' => info_url,
    'date_scraped' => Date.today.to_s,
    'date_received' => Date.parse(row[:content]["Application Date"]).to_s
  }
  puts "Storing " + record['council_reference'] + " - " + record['address']
#     puts record
  ScraperWiki.save_sqlite(['council_reference'], record)
end
