require 'epathway_scraper'

info_url = 'https://eservices.southgippsland.vic.gov.au/ePathway/ePathProd/Web/GeneralEnquiry/EnquiryLists.aspx?ModuleCode=LAP'

scraper = EpathwayScraper::Scraper.new(
  base_url: info_url,
  index: 0
)

page = scraper.pick_type_of_search

scraper.scrape_index_page(page) do |record|
  puts "Storing " + record['council_reference'] + " - " + record['address']
  ScraperWiki.save_sqlite(['council_reference'], record)
end
