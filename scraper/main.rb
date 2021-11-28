require 'open-uri'

require 'nokogiri'

# https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao=
# https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?page=2&tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao=
# https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?page=3&tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao=
# https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?page=4&tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao=
# https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?page=5&tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao=
#### beginning of url generation
################### FIRST PAGE START AT INDEX ONE (1) #####################
# do while there is no 404 error
url_part1 = "https://sapl.camaranh.rs.gov.br/materia/pesquisar-materia?page="
index = 5 # get/set index page here (START AT 1 / PAGE ONE)
url_part2 = "&tipo=1&ementa=&numero=&numeracao__numero_materia=&numero_protocolo=&ano=&o=&tipo_listagem=1&tipo_origem_externa=&numero_origem_externa=&ano_origem_externa=&data_origem_externa_0=&data_origem_externa_1=&local_origem_externa=&data_apresentacao_0=&data_apresentacao_1=&data_publicacao_0=&data_publicacao_1=&autoria__autor=&autoria__primeiro_autor=unknown&autoria__autor__tipo=&autoria__autor__parlamentar_set__filiacao__partido=&relatoria__parlamentar_id=&em_tramitacao=&tramitacao__unidade_tramitacao_destino=&tramitacao__status=&materiaassunto__assunto=&indexacao="
# add everything up to form final url pathway
url_final = url_part1 + index.to_s + url_part2 
# end when a error is catched (rescue)
### end of url generation

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
