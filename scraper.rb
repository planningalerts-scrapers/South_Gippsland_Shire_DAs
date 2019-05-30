require 'epathway_scraper'

EpathwayScraper::Scraper.scrape_and_save(
  "https://eservices.southgippsland.vic.gov.au/ePathway/ePathProd",
  list_type: :advertising
)
