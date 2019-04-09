class Activity < ActiveRecord::Base
  belongs_to :vote, required: false

  def self.infer_meetings
    prev_time = Activity.first.created_at
    meetings = []
    current_meeting = []
    Activity.all.each do |activity|
      if (activity.created_at - prev_time) > 60 * 60
        meetings.push(current_meeting.clone)
        current_meeting = [activity]
      else
        current_meeting.push(activity)
        prev_time = activity.created_at
      end
    end
    meetings.push(current_meeting.clone)
    meetings
  end
end
