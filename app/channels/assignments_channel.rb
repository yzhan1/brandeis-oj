class AssignmentsChannel < ApplicationCable::Channel  
  def subscribed
    puts '****** subscribed to assignments channel'
    stream_from 'assignments'
  end
end