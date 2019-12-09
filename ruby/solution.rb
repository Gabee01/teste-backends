require 'csv'

class Solution
  # Essa função recebe uma lista de mensagens, por exemplo:
  #
  # [
  #   "72ff1d14-756a-4549-9185-e60e326baf1b,proposal,created,2019-11-11T14:28:01Z,80921e5f-4307-4623-9ddb-5bf826a31dd7,1141424.0,240",
  #   "af745f6d-d5c0-41e9-b04f-ee524befa425,warranty,added,2019-11-11T14:28:01Z,80921e5f-4307-4623-9ddb-5bf826a31dd7,31c1dd83-8fb7-44ff-8cb7-947e604f6293,3245356.0,DF",
  #   "450951ee-a38d-475c-ac21-f22b4566fb29,warranty,added,2019-11-11T14:28:01Z,80921e5f-4307-4623-9ddb-5bf826a31dd7,c8753500-1982-4003-8287-3b46c75d4803,3413113.45,DF",
  #   "66882b68-baa4-47b1-9cc7-7db9c2d8f823,proponent,added,2019-11-11T14:28:01Z,80921e5f-4307-4623-9ddb-5bf826a31dd7,3f52890a-7e9a-4447-a19b-bb5008a09672,Ismael Streich Jr.,42,62615.64,true"
  # ]
  #
  # Complete a função para retornar uma string com os IDs das propostas válidas no seguinte formato (separado por vírgula):
  # "52f0b3f2-f838-4ce2-96ee-9876dd2c0cf6,51a41350-d105-4423-a9cf-5a24ac46ae84,50cedd7f-44fd-4651-a4ec-f55c742e3477"
  def process_messages(messages)
    messages.each do |message|
      parse_message(message)
    end
  end

  def parse_message(message)
    attrs = CSV.parse(message)
    entity = attrs[1]

    proposal = new Handler(attrs)


    # proposal.created: event_id,event_schema,event_action,event_timestamp,proposal_id,proposal_loan_value,proposal_number_of_monthly_installments
    #   enviado quando uma proposta é criada
    # proposal.updated: event_id,event_schema,event_action,event_timestamp,proposal_id,proposal_loan_value,proposal_number_of_monthly_installments
    #   enviado quando uma proposta é atualizada
    # proposal.deleted: event_id,event_schema,event_action,event_timestamp,proposal_id
    #   enviado quando uma proposta é excluída
    # warranty.added: event_id,event_schema,event_action,event_timestamp,proposal_id,warranty_id,warranty_value,warranty_province
    #   enviado quando um imóvel de garantia é adicionado à uma proposta
    # warranty.updated: event_id,event_schema,event_action,event_timestamp,proposal_id,warranty_id,warranty_value,warranty_province
    #   enviado quando um imóvel de garantia é atualizado
    # warranty.removed: event_id,event_schema,event_action,event_timestamp,proposal_id,warranty_id
    #   enviado quando um imóvel de garantia é removido de uma proposta
    # proponent.added: event_id,event_schema,event_action,event_timestamp,proposal_id,proponent_id,proponent_name,proponent_age,proponent_monthly_income,proponent_is_main
    #   enviado quando um proponente é adicionado à uma proposta
    # proponent.updated: event_id,event_schema,event_action,event_timestamp,proposal_id,proponent_id,proponent_name,proponent_age,proponent_monthly_income,proponent_is_main
    #   enviado quando um proponente é atualizado
    # proponent.removed: event_id,event_schema,event_action,event_timestamp,proposal_id,proponent_id
    #   enviado quando um proponente é removido de uma proposta


  end
end
