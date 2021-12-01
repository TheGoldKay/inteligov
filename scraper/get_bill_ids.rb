require 'open-uri'
require 'nokogiri'
require 'json'
require 'set'
require 'csv'

def fetch_bill_codes
    page_index = 1
    final_page_index = 41 # NEEDS TO BE CHANGED -ASAP-
    url_part1 = "https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?page="
    url_part2 = "&tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao="
    url_base = "https://sapl.camaranh.rs.gov.br/materia/"

    is_not_downloaded = "OFF"

    begin 
        all_bill_numbers = []
        while true 
            url = url_part1 + page_index.to_s + url_part2
            doc = Nokogiri::HTML.parse(URI.open(url))
            list = doc.css('a').map { |link| link['href']}
            puts 
            puts "\t\t\t\t\t\t\t\t\tPage Index/Number: #{page_index}*"
            list.each do |item| 
                arr = item.split('/')
                if arr[1] == 'materia' and arr[2] =~ /\d/ and arr.length() - arr.count("") == 2  then 
                    bill_number = arr[2]
                    all_bill_numbers << bill_number
                    puts "\t\t\t\t\t\t\t\t\t Bill's Code: #{bill_number}"
                end 
            end 
            puts 
            page_index = page_index + 1 
        end 
    rescue 
        puts 
        puts "\t\t\t*** Number Of Bills Found: #{all_bill_numbers.length()} ***"
        puts 
        if page_index == final_page_index then 
            puts "\t\t\t----->     EVERYTHING'S GREEN      <-----"
            puts "\t\t\t-----> ALL JOBS HAVE BEEN FINISHED <-----"
        else  
            puts "\t\t\t      SOMETHING WENT TERRIBLY WRONG      "
            puts "\t\t\t----->       RED FLAG FOUND        <-----"
            puts "\t\t\t----->     CLOSING UP SCRAPER      <-----"
        end 
    end 

    CSV.open("data/ids.csv", "w") do |csv|
        all_bill_numbers.each do |bill_code|
            csv << [bill_code, is_not_downloaded] 
        end 
    end

    File.open("data/total_number_of_bills.txt", "w") do |file|
        file << all_bill_numbers.length()
    end 
end 

fetch_bill_codes