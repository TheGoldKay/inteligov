require 'open-uri'
require 'nokogiri'
require 'json'
require 'set'
require 'csv'

ids_text = File.read('ids.csv')
all_bill_numbers = CSV.parse(ids_text, :headers => true)

json_files_path = "bills_json_data/"


bill_index = 0
url_site_base = "https://sapl.camaranh.rs.gov.br"
bill_url = "https://sapl.camaranh.rs.gov.br/materia/" # number comes after '/materia/BILL_NUMBER'
all_bill_numbers.each do |num| 
    num_bills = Dir.glob(File.join("bill_pdf_odt_files", '**', '*')).select { |file| File.file?(file) }.count
    #puts "BILL INDEX: #{bill_index} <-------------------------> Bill Count: #{num_bills}"
    url = bill_url + num.to_s.strip
    doc = Nokogiri::HTML(URI.open(url))
    bill_name = doc.search("h1").text.strip
    bill_ementa = doc.at_css("div#div_id_ementa").text.strip
    ementa_arr = bill_ementa.split("\n")
    bill_ementa = ementa_arr[ementa_arr.length() - 1].strip
    bill_date = doc.at_css("div#div_id_data_apresentacao").text.strip
    data_arr = bill_date.split("\n")
    bill_date = data_arr[data_arr.length() - 1].strip
    #print "Bill's Name: #{bill_name}"
    #puts 
    #print "Bill's Ementa: #{bill_ementa}"
    #puts 
    file_name = doc.at_css("div#div_id_texto_original").at_css('div').at_css('div').text
    file_path = doc.at_css("div#div_id_texto_original").at_css('div').at_css('div').at_css('a')['href']
    file_path = url_site_base + file_path     
    #print "Bill's Original Text: #{file_path}" 
    #puts     
    #print "Bill's Data: #{bill_date}"
    #puts
=begin
    URI.open(file_path) do |in_io|
        File.open(files_dir + file_name, 'w') do |out_io|
            out_io.print in_io.read
        end
    end
=end
    authors = Nokogiri::HTML(URI.open(url+"/autoria"))
    a_list = authors.css('tbody').css('td').css('a').map { |author| author.text.strip}
    #puts "List Of Authors: #{a_list}"

    bill_status = Nokogiri::HTML(URI.open(url + "/tramitacao"))
    s_list = bill_status.css('tbody').css('tr').map{|item| item.text}#.map {|item| item.css('td').text.split("\n").to_a.map{|i| i.gsub! " ", ""}.delete_if{|i| i == "" or i == nil}}
    lists = []
    s_list.each do |item|
        list = item.split("\n").map{|i| i.strip}.delete_if{|j| j == "" or j == nil}
        lists.append(list)
        #print list, list.length()
        #puts
    end 
    #print lists 
    #puts 
    #puts "STATUS: #{lists}"

    #bill_status.css('tbody').each do |x| 
    #    puts x.css('td').text.strip.split("\n").to_a.map{|item| item.strip.split('\n')}
    #end 
    #puts "Status List: #{s_list}"

    #puts "<<<<<--------------------------------------------------------------------->>>>>" 
    status_json_lists = []
    lists.each do |l| 
        status_json = {
            "date" => l[0],
            "unidade_local" => l[1],
            "unidade_destine" => l[2],
            "status" => l[3]
        }
        status_json_lists.append(status_json)
    end 
    actual_bill = {
        "name" => bill_name,
        "ementa" => bill_ementa,
        "bill_text_link" => file_path,
        "date" => bill_date,
        "authors" => a_list,
        "status" => status_json_lists
    }
    puts "         <<<<<------------------------------------------------------------------------>>>>>" 
    puts JSON.pretty_generate(actual_bill)
    puts "         <<<<<------------------------------------------------------------------------>>>>>" 
    json_name = file_name.split(".")[0]
    File.open(json_files_path + json_name + ".json", "w") do |f|
        f.write(actual_bill.to_json)
    end 
    bill_index = bill_index + 1
end  
