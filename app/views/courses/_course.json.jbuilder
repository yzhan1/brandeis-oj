json.extract! course, :id, :course_title, :teacher_id, :course_code, :created_at, :updated_at
json.url course_url(course, format: :json)
