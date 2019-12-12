Os testes de 1 à 12 estão passando normalmente.

O teste numero 13 possui uma inconsistencia com a especificação, a saída da solução apresentada indica que a proposta 89892de7-06fa-4c52-880b-6d9e1ddc951e é valida, enquanto na saida esperada, a mesma é considerada invalida.

Isso acontece devido ao evento com id duplicado: 5b924f17-f2a9-4bdf-97da-b57a4f49c615

a entrada é na seguinte order:
5b924f17-f2a9-4bdf-97da-b57a4f49c615,proponent,added,2019-11-11T21:03:12Z,89892de7-06fa-4c52-880b-6d9e1ddc951e,4ee3e203-5afb-43e5-a627-22973b2f566c,Alexis Altenwerth I,44,21305.38,true
5b924f17-f2a9-4bdf-97da-b57a4f49c615,proponent,updated,2019-11-11T21:04:12Z,89892de7-06fa-4c52-880b-6d9e1ddc951e,4ee3e203-5afb-43e5-a627-22973b2f566c,Alexis Altenwerth I,12,21305.38,true

conforme a especificação: 
"Em caso de eventos repetidos, considere o primeiro evento
    Por exemplo, ao receber o evento ID 1 e novamente o mesmo evento, descarte o segundo evento"
A solução está programada para persistir apenas o primeiro evento. Assim a idade do proponente continua 44 após o processamento das mensagens, sendo que o evento de atualização que atualizaria a idade do proponente para 12 anos e invalidaria sua proposta nunca é persistido.

Nos testes unitários, foi usado como base o caso acima, utilizei duas propostas do teste numero 13 para reproduzir o comportamento.
Escrevi um teste unitário para garantir que mensagens com id repetidos estão sendo ignoradas.

Também escrevi testes para garantir que inserção, remoção e atualização de proponentes e garantias estão funcionando.