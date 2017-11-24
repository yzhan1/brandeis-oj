require 'csv'

module CoursesHelper
  def build_csv entries
    CSV.generate do |csv|
      csv << ['Brandeis ID', 'Student Name', 'Grade']
      entries.each do |entry|
        u = entry.user
        next if u == current_user
        brandeis_id = /^[^@]*/.match u.email
        csv << [brandeis_id, u.name, entry.grade]
      end
    end
  end
end
