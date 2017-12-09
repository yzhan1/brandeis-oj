class AssignmentsChannel < ApplicationCable::Channel  
  def subscribed
    puts "****** subscribed to assignments#{params[:course]}"
    stream_from "assignments#{params[:course]}"
  end
end