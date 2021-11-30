
require 'resolv-replace'

if not File.exist?('ids.csv') then 
    system 'ruby scraper/get_bill_ids.rb'
end 



def main 
    number_of_bills = File.open("total_number_of_bills.txt", "r")
    count = Dir.glob(File.join("bill_pdf_odt_files", '**', '*')).select { |file| File.file?(file) }.count
    if count.to_i == number_of_bills.to_i then 
        return 
    end
    begin 
        system "ruby scraper/download.rb"
    rescue 
        count = Dir.glob(File.join("bill_pdf_odt_files", '**', '*')).select { |file| File.file?(file) }.count
        if count.to_i != number_of_bills.to_i then 
            return main() 
        end 
    end 
end 

main()