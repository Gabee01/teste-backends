class Handler
  def initialize(message_attrs)
    entity = message_attrs[1]
    action = message_attrs[2]
  end

  def perform_action
    case action
    when 'created'
      proposal_created(event_id,event_schema,event_action,event_timestamp,proposal_id,proposal_loan_value,proposal_number_of_monthly_installments)
    when 'updated'
      proposal_updated(event_id,event_schema,event_action,event_timestamp,proposal_id,proposal_loan_value,proposal_number_of_monthly_installments)
    when 'deleted'
      proposal_deleted(event_id,event_schema,event_action,event_timestamp,proposal_id)
    end
  end
end