# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE

# # Read in a page
page = agent.get("https://eservices.southgippsland.vic.gov.au/ePathway/ePathProd/Web/GeneralEnquiry/EnquiryLists.aspx?ModuleCode=LAP")
@comment_url = "https://www.southgippsland.vic.gov.au/site/scripts/xforms_form.php?formID=193"
@date_scraped = Date.today.to_s

def scrape_details(new_page, new_date)
#  puts "\nD: #{new_page.title}"
#  details_page = agent.get(new_page)
#  puts "   s: #{details_page.text}"
#                  /html/body/form/div[3]/table[2]/tbody/tr/td/div/fieldset/table[2]/tbody/tr[1]/td/div/table[2]/tbody/tr[4]/td[2]/span
  council_reference = new_page.at("/html/body/form/div/table[2]/tr/td/div/table[2]/tr[1]/td/div/table[2]/tr[3]/td[2]/*").text
  address = new_page.at("/html/body/form/div/table[2]/tr/td/div/table[2]/tr[1]/td/div/table[2]/tr[4]/td[2]/*").text
  type = new_page.at("/html/body/form/div/table[2]/tr/td/div/table[2]/tr[1]/td/div/table[2]/tr[1]/td[2]/*").text
  description = "#{new_page.at("/html/body/form/div/table[2]/tr/td/div/table[2]/tr[1]/td/div/table[2]/tr[2]/td[2]/*").text} (#{type})"
  info_url = new_page.at("/html/body/form/div/table[2]/tr/td/div/table[2]/tr[4]/td/div/table[2]/tr/td[2]/a").attribute("href").to_s

  date_received = new_date.to_s
  on_notice_from = new_date.to_s
  on_notice_to = (new_date+14).to_s
  
  status_field = new_page.at("/html/body/form/div/table[2]/tr/td/div/table[2]/tr[1]/td/div/table[2]/tr[5]/td[2]/*")
  who_field = new_page.at("/html/body/form/div/table[2]/tr/td/div/table[2]/tr[1]/td/div/table[2]/tr[6]/td[2]/*")
#  puts "     -ref: #{council_reference}"
#  puts "     -Add: #{address}"
#  puts "     -desc: #{description}"
#  puts "     -url: #{info_url}"
#  puts "     -date rec: #{date_received}"
#  puts "     -date from: #{on_notice_from}"
#  puts "     -date to: #{on_notice_to}" # on advertisement for 14 days

#  puts "     -S: #{status_field.text}"
#  puts "     -W: #{who_field.text}"
  record = {
    'council_reference' => council_reference,
    'address' => address,
    'description' => description,
    'info_url' => info_url,
    'date_received' => date_received,
    'on_notice_from' => on_notice_from,
    'on_notice_to' => on_notice_to,
    'date_scraped' => @date_scraped,
    'comment_url' => @comment_url,
  }

  puts "\n :: RECORD :: \n#{record}"

  if (ScraperWiki.select("* from data where `council_reference`='#{record['council_reference']}'").empty? rescue true)
    ScraperWiki.save_sqlite(['council_reference'], record)
  else
    puts "Skipping already saved record " + record['council_reference']
  end

end


page.links.each do |link|
  if link.href.to_s["EnquiryDetailView"]
    new_page = link.click
    new_date = Date.parse(link.node.parent.parent.next_sibling.next_sibling.next_sibling.text)
#    puts "date: #{date}"
    scrape_details(new_page, new_date)
  end
end

#
# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".
