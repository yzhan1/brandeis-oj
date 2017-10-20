crumb :root do
  link "Dashboard", dashboard_path
end

crumb :dashboard do
  link "Dashboard", dashboard_path
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
  link "Submissions for #{assignment.name}", assignment
  parent :course, assignment.course
end

crumb :submission do |submission|
  link "Submission from #{submission.user.name}", submission
  parent :submissions, submission.assignment
end

crumb :user do |user|
  link "My Profile", user
end

crumb :edit_user do |user|
  link "Edit My Profile", user
  parent :user, user
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end