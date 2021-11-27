require 'open-uri'

require 'nokogiri'

index = 1
url = 'https://sapl.camaranh.rs.gov.br/sistema/search/?q=Projeto%20de%20Lei&page='

def data_parser url   
    #fh = open(url)
    #html = fh.read
    parsed_data = Nokogiri::HTML.parse(open(url))
    #puts parsed_data.title
    puts parsed_data.class
end 
data_parser 'https://sapl.camaranh.rs.gov.br/sistema/search/?q=Projeto%20de%20Lei&page=1'
=begin
while true 
    begin 
        #puts html
        puts "THIS IS PAGE NUMER #{index}"
        parser url + index 
    rescue
        puts "SOMETHING WENT WRONG"
    end 
    index = index + 1
end 
end
