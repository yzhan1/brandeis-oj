class SubmissionsChannel < ApplicationCable::Channel  
  def subscribed
    puts "****** subscribed to submissions#{params[:assignment]}"
    stream_from "submissions#{params[:assignment]}"
  end
end