json.extract! detail, :id, :loan, :term, :rate, :disburse_date, :pay_strt_date, :created_at, :updated_at
json.url detail_url(detail, format: :json)
