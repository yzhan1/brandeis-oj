class SubmissionMailer < ApplicationMailer
  def grade_notification submission, instructor
    @instructor = instructor
    @submission = submission
    @assignment = submission.assignment
    @recepient = submission.user
    mail to: @recepient.email, subject: "#{@instructor.name} has given grade for your submission to assignment #{@assignment.name}"
  end
end
