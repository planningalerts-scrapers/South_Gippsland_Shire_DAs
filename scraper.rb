require 'epathway_scraper'

EpathwayScraper.scrape_and_save(
  "https://eservices.southgippsland.vic.gov.au/ePathway/ePathProd",
  list_type: :advertising
)
