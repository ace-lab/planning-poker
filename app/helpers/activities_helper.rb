module ActivitiesHelper
  def meeting_start(meetings)
    meetings.first.created_at
  end

  def meeting_length(meetings)
    ((meetings.last.created_at - meetings.first.created_at) / 60.0).round(2)
  end

  def num_stories_updated(meetings)
    meetings.select { |act| act.activity_type.eql? 'dashboard#update' }
            .map(&:story_id).uniq.length
  end

  def num_votes(meetings)
    meetings.select { |act| act.activity_type.eql? 'dashboard#vote' }.length
  end

  def num_participants(meetings)
    meetings.map(&:username).uniq.length
  end
end
