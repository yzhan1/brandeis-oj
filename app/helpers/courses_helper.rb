require 'csv'

module CoursesHelper
  def build_csv course
    csv_string = CSV.generate do |csv|
      csv << ['Brandeis ID', 'Student Name', 'Grade']
      course.enrollments.each do |enrollment|
        u = enrollment.user
        next if u == current_user
        brandeis_id = /^[^@]*/.match u.email
        csv << [brandeis_id, u.name, enrollment.final_grade]
      end
    end
  end
end
