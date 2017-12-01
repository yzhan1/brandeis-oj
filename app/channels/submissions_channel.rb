class SubmissionsChannel < ApplicationCable::Channel  
  def subscribed
    puts '****** subscribed to submissions channel'
    stream_from 'submissions'
  end
end