
require 'resolv-replace'

if not File.exist?("data/ids.csv") then 
    system 'ruby scraper/get_bill_ids.rb'
end 



def main reset = "yes" 
    begin 
        if reset == "yes"
            File.delete("data/ids.csv") if File.exist?("data/ids.csv")
            File.delete("data/total_number_of_bills.txt") if File.exist?("data/total_number_of_bills.txt")
            system "ruby scraper/get_bill_ids.rb"
            system "ruby scraper/download.rb"
        else
            system "ruby scraper/download.rb"
        end 
    rescue => e
        puts e.message 
        puts e.backtrace 
    end 
end 

reset_everything = ARGV[0]

main(reset_everything)