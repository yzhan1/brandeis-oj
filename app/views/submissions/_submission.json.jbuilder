json.extract! submission, :id, :submitted, :user_id, :assignment_id, :submission_date, :source_code, :grade, :created_at, :updated_at
json.url submission_url(submission, format: :json)
