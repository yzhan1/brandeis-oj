json.extract! student, :id, :name, :email, :password, :created_at, :updated_at
json.url student_url(student, format: :json)
