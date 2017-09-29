json.extract! teacher, :id, :name, :email, :password, :created_at, :updated_at
json.url teacher_url(teacher, format: :json)
