class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :vote, required: false

  class << self
    def discuss_time(story_id)
      activities = Activity.activities_for_story(story_id)
      vote_start = Activity.voting_start_time(activities) 
      discussion_start = Activity.discussion_start_time(activities, vote_start)
      if (vote_start == 0 and discussion_start != 0) or (vote_start != 0 and discussion_start == 0)
        -1
      else   
        (vote_start - discussion_start) / 60
      end
    end

    def vote_variance(story_id)
      activities = Activity.where(story_id: story_id, activity_type: 'dashboard#vote').all
      votes = activities.map do |act|
        JSON.parse(act.activity_data)['vote'].to_f
      end
      sum = votes.sum
      mean = sum / votes.length.to_f
      variance = votes.inject(0.0) { |tsum, vt| tsum + (vt - mean)**2 }
      variance = variance / (votes.length).to_f
      Math.sqrt variance
    end

    def updated_by(story_id)
      user_id = Activity.where(activity_type: 'dashboard#update', story_id: story_id).last.user_id
      User.where(id: user_id).first.username
    end

    def activities_for_story(story_id)
      Activity.order(:created_at).where(story_id: story_id)
    end

    def discussion_start_time(activities, end_range)
      relevant_activity = activities.where("activity_type='dashboard#detail' AND created_at <= ?", end_range).last
      if relevant_activity
        relevant_activity.created_at
      else
        0
      end
    end

    def voting_start_time(activities)
      relevant_activity = activities.where(activity_type: 'dashboard#discussion').last
      if relevant_activity
        relevant_activity.created_at
      else
        0
      end
    end
  end

end
