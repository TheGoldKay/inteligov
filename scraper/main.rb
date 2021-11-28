require 'open-uri'

require 'nokogiri'

# https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao=
# https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?page=2&tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao=
# https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?page=3&tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao=
# https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?page=4&tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao=
# https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?page=5&tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao=
#### beginning of url generation
=begin
################### FIRST PAGE START AT INDEX ONE (1) #####################
# do while there is no 404 error
url_part1 = "https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?page="
index = 5 # get/set index page here (START AT 1 / PAGE ONE)
url_part2 = "&tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao="
# add everything up to form final url pathway
url_final = url_part1 + index.to_s + url_part2 
# end when a error is catched (rescue)
### end of url generation
=end 
system 'clear'
puts "\n\n"
page_index = 1
final_page_index = 41 
url_part1 = "https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?page="
url_part2 = "&tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao="
while true 
    puts "ALL GREEN FOR PAGE INDEX > " + page_index.to_s 
    begin 
    url = url_part1 + page_index.to_s + url_part2
    parsed_data = Nokogiri::HTML.parse(URI.open(url))
    #puts parsed_data
    rescue 
        puts "SOMETHING WENT TERRIBLE WRONG"
        break
    end 
    page_index = page_index + 1 
    #puts "\n\n\n\n\n"
    #puts "ALL GREEN FOR PAGE INDEX > " + page_index.to_s 
    #system 'clear'
end 
system 'clear'
if page_index == final_page_index then 
    puts "----->     EVERYTHING'S GREEN      <-----"
    puts "-----> ALL JOBS HAVE BEEN FINISHED <-----"
    puts "----->     CLOSING UP SCRAPER      <-----"
else 
    puts "----->       RED FLAG FOUND        <-----"
    puts "----->     CLOSING UP SCRAPER      <-----"
end 
=begin
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
=end