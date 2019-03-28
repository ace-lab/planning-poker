module ActivitiesHelper
  def activity_type(activity)
    if activity.activity_type.start_with? 'dashboard'
      activity.story_id.nil? ? 'unstarted' : 'accepted'
    else
      'started'
    end
  end
end
