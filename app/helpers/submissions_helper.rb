module SubmissionsHelper
  def run_code submission_id
    job_id = CompileWorker.perform_async submission_id
    {"id" => job_id}
  end

  def completed? job_id
    if Sidekiq::Status::complete? job_id
      data = {"output" => Sidekiq::Status::get_all(job_id)["stdout"].split("\n")}
    else
      data = {"message" => "Processing"}
    end
  end

  def broadcast_submission submission
    assignment_id = submission.assignment.id
    ActionCable.server.broadcast("submissions#{assignment_id}", 
      from: submission.user.name, 
      link: "/submissions/#{submission.id}",
      date: submission.submission_date.strftime('%a, %b %d %Y, %H:%M'),
      grade: submission.grade,
      assignment_id: assignment_id
    )
  end

  def update_score submission, count
    enrollment = submission.assignment.course.enrollments.find submission.user.id
    enrollment.update(total: enrollment.total + submission.grade, count: enrollment.count + count)
    enrollment.update(grade: enrollment.total / enrollment.count)
  end
end
