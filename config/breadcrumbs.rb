crumb :root do
  link "Dashboard", dashboard_path
end

crumb :dashboard do
  link "", dashboard_path
end

crumb :course do |course|
  link course.course_title, course
end

crumb :add_course do
  link "Add Course", new_course_path
end

crumb :edit_course do |course|
  link "Edit Course", course
  parent :course, course
end

crumb :course_grades do |course|
  link "All Grades", grades_course_url
  parent :course, course
end

crumb :assignment do |assignment|
  link assignment.name, assignment
  parent :course, assignment.course
end

crumb :add_assignment do
  link "Add Assignment", new_assignment_path
end

crumb :edit_assignment do |assignment|
  link "Edit Assignment", assignment
  parent :course, assignment.course
end

crumb :submissions do |assignment|
  link "Submissions (assignment ##{assignment.id})", assignment
  parent :course, assignment.course
end

crumb :submission do |submission|
  link "Submission", submission
  if is_student?
    parent :course, submission.assignment.course
  else
    parent :submissions, submission.assignment
  end
end

crumb :user do |user|
  link "My Profile", user
end

crumb :edit_user do |user|
  link "Edit My Profile", user
  parent :user, user
end