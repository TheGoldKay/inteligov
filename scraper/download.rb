require 'open-uri'
require 'nokogiri'
require 'json'
require 'set'
require 'csv'

bills_json_data = "bills_json_data/"
ids_path = "data/ids.csv"
total_number_of_bills = "data/total_number_of_bills.txt"

def get_bill_codes
    ids_text = File.read("data/ids.csv")
    all_bill_numbers = CSV.parse(ids_text, :headers => true)
    return all_bill_numbers
end 

def bill_count_on_off 
    all_bill_numbers = get_bill_codes
    on = 0
    off = 0
    all_bill_numbers.each_with_index do |val, i| 
        if val[1] == "ON" then 
            on += 1 
        else 
            off += 1
        end 
    end 
    {'ON' => on, 'OFF' => off}
end 
 
def update_ids new_bill_list
    File.write("data/ids.csv", new_bill_list)
end 

def get_bill_index_code 
    all_bill_numbers = get_bill_codes
    new_bill_list = all_bill_numbers
    all_bill_numbers.each_with_index do |row, index|
        code_num, download_status = row[0], row[1]
        if download_status == "OFF" then
            new_bill_list[index][0] = code_num
            new_bill_list[index][1] = "ON"
            update_ids new_bill_list
            return {"row" => index, "num" => code_num}
        end 
    end  
end

def codes_left 
    all_bill_numbers = get_bill_codes
    all_bill_numbers.each do |row| 
        if row[1] == "OFF" then 
            return true 
        end 
    end 
    return false 
end 


def download bill_url, url_site_base 
    #all_bill_numbers.each do |num| 
    num_bills = Dir.glob(File.join("bills_json_data/", '**', '*')).select { |file| File.file?(file) }.count
    max_bill_index = File.open("data/total_number_of_bills.txt", "r").to_i
    while codes_left do 
        line = get_bill_index_code
        num, row = line["num"], line["row"]
        all_bill_numbers = get_bill_codes
        c = bill_count_on_off
        puts "\t\t\t\t\t|\t\t\t\t\t\t\t\t\t\t|"
        puts "\t\t\t\t\tCurrent Bill Code/Number: #{num} <!> Bill Count: #{num_bills} <!> ON: #{c['ON']} <!> OFF: #{c['OFF']}"
        puts "\t\t\t\t\t|\t\t\t\t\t\t\t\t\t\t|"
        #num = all_bill_numbers[bill_index]
        #puts num
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
            "id" => num,
            "name" => bill_name,
            "ementa" => bill_ementa,
            "bill_text_link" => file_path,
            "date" => bill_date,
            "authors" => a_list,
            "status" => status_json_lists
        }
        #puts "         <<<<<------------------------------------------------------------------------>>>>>" 
        #puts JSON.pretty_generate(actual_bill)
        #puts "         <<<<<------------------------------------------------------------------------>>>>>" 
        json_name = file_name.split(".")[0]
        File.open("bills_json_data/" + json_name + ".json", "w") do |f|
            f.write(actual_bill.to_json)
        end 
        num_bills = Dir.glob(File.join("bills_json_data/", '**', '*')).select { |file| File.file?(file) }.count
    end  
end 

def fetch_data
    all_bill_numbers = get_bill_codes 
    begin 
        url_site_base = "https://sapl.camaranh.rs.gov.br"
        bill_url = "https://sapl.camaranh.rs.gov.br/materia/" # number comes after '/materia/BILL_NUMBER'
        download bill_url, url_site_base
    rescue => e
        puts e.message 
        puts e.backtrace 
        number_of_bills = File.open("data/total_number_of_bills.txt", "r")
        num_bills = Dir.glob(File.join("bills_json_data/", '**', '*')).select { |file| File.file?(file) }.count
        if num_bills.to_i != number_of_bills.to_i then 
            return fetch_data()
        else 
            return 
        end 
    end 
end 

fetch_data