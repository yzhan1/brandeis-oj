module AssignmentsHelper
  def test_code(assignment_id)
    job_id = TestsWorker.perform_async(assignment_id)
    {"id" => job_id}
  end

  def test_completed?(job_id)
    if Sidekiq::Status::complete? job_id
      sub_list = Sidekiq::Status::get_all(job_id)["all_jobs"]
      sub_list = sub_list.split(',')
      puts "The parsed array is: #{sub_list.inspect}"
      if sub_list.empty?
        data = {"output" => "<br>"}
        return data
      end
      sub_list.each do |sub_id|
        puts "sub_id is: #{sub_id}"
        if !Sidekiq::Status::complete? sub_id
          data = {"message" => "Processing"}
          return data
        end
      end
      temp = ""
      count = 0
      sub_list.each do |sub_id|
        count = count + 1
        temp = "#{temp}<br/>#{count}. #{Sidekiq::Status::get_all(sub_id)["stdout"]}"
      end
      temp = "#{temp}<br/>"
      data = {"output" => "#{temp}"}
    elsif !Sidekiq::Status::failed? job_id
      data = {"message" => "Processing"}
    else
      data = {"output" => "At least one test has failed."}
    end
  end

  def send_msg_notification assignment
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    assignment.course.users.each do |user|
      next if user == current_user || user.phone.nil?
      @client.messages.create(
        body: "New assignment has been posted: #{assignment.name} for course #{assignment.course.course_title}.
               Due date is #{assignment.due_date.strftime('%a, %b %d %Y, %H:%M')}",
        to:   "+#{user.phone}",
        from:  ENV['TWILIO_NUMBER']
      )
    end
  end

  def broadcast_assignment assignment
    course_id = @assignment.course.id
    ActionCable.server.broadcast("assignments#{course_id}",
      name: @assignment.name,
      link: "/assignments/#{@assignment.id}",
      due_date: @assignment.due_date.strftime('%a, %b %d %Y, %H:%M'),
      course_id: course_id
    )
  end
end
