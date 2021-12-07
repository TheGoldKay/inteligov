require 'json'
require 'csv'

#id | code | name | ementa | bill_text_link | date | authors | status | created_at | updated_at 
def parser
    CSV.open("csv_data/fulldata.csv", "w") do |row|
        Dir.glob("scraper_data/*.json") do |file|
            data = File.read(file)
            json = JSON.parse(data)
            code = json["code"]
            name = json["name"]
            ementa = json["ementa"]
            link = json["bill_text_link"]
            date = json["date"]
            authors = json["authors"]
            alen = authors.length - 1
            alist = []
            (0..(alen-1)).each do |i|
                #"date", "unidade_local", "unidade_destine", "status"
                line = [authors[i.to_s]["date"], authors[i.to_s]["unidade_local"], authors[i.to_s]["unidade_destine"], authors[i.to_s]["status"]]
                alist.append(line.to_a)
            end 
            status = json["status"]
            slen = status.length - 1
            slist = []
            (0..(slen-1)).each do |i|
                #"name"
                slist.append(status[i.to_s])
            end 
            row << [code.to_i, name, ementa, link, date, alist, slist.to_a]
        end   
    end  
end   

parser 