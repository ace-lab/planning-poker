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
      end
      prev_time = activity.created_at
    end
    meetings.push(current_meeting.clone)
    meetings
  end

  def self.to_csv
    attributes = %w{id username project_id story_id activity_type activity_data created_at}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |activity|
        csv << activity.attributes.values_at(*attributes)
      end
    end
  end
end
