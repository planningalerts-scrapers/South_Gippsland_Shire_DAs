require 'epathway_scraper'

info_url = 'https://eservices.southgippsland.vic.gov.au/ePathway/ePathProd/Web/GeneralEnquiry/EnquiryLists.aspx?ModuleCode=LAP'

scraper = EpathwayScraper::Scraper.new(
  base_url: info_url,
  index: 0
)

page = scraper.pick_type_of_search

scraper.extract_table_data_and_urls(page.at("table.ContentPanel")).each do |row|
  data = scraper.extract_index_data(row)

  record = {
    'council_reference' => data[:council_reference],
    'address' => data[:address],
    'description' => data[:description],
    'info_url' => info_url,
    'date_scraped' => Date.today.to_s,
    'date_received' => data[:date_received]
  }
  puts "Storing " + record['council_reference'] + " - " + record['address']
#     puts record
  ScraperWiki.save_sqlite(['council_reference'], record)
end
