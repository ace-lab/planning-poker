class Vote < ActiveRecord::Base
  class << self

    def set(params)
      vote = Vote.where(
        user:     params[:user],
        story_id: params[:story_id]
      ).first

      if vote
        vote.update(:vote => params[:vote].to_i)
      else
        Vote.create(
          user:     params[:user],
          story_id: params[:story_id],
          vote:     params[:vote]
        )
      end
    end

    def reset(params)
      vote = Vote.where(
        user:     params[:user],
        story_id: params[:story_id]
      ).first

      vote.destroy if vote
    end

    def stories
      updated = Activity.where(activity_type: 'dashboard#update').map(&:story_id).to_set
      selected = Activity.where(activity_type: 'dashboard#select').map(&:story_id).to_set
      updated & selected
    end

  end
end
