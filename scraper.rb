require 'epathway_scraper'

scraper = EpathwayScraper::Scraper.new(
  base_url: 'https://eservices.southgippsland.vic.gov.au/ePathway/ePathProd/Web/GeneralEnquiry/EnquiryLists.aspx?ModuleCode=LAP',
  index: 0
)

scraper.scrape_and_save
