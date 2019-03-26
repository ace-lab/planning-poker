require 'rails_helper'

describe Activity, type: :model do
    before do
        Activity.delete_all
    end

    context "#discuss_time" do
        before do
            Activity.create({ user_id: '1', activity_type: 'dashboard#detail', created_at: Time.now, story_id: 1234 }).save!
            Activity.create({ user_id: '1', activity_type: 'dashboard#detail', created_at: Time.now, story_id: 1234 }).save!
            Activity.create({ user_id: '1', activity_type: 'dashboard#detail', created_at: Time.now + (60*60*3), story_id: 1234 }).save!
            Activity.create({ user_id: '1', activity_type: 'dashboard#discussion', created_at: Time.now + (60*60*4), story_id: 1234 }).save!
            Activity.create({ user_id: '1', activity_type: 'dashboard#discussion', created_at: Time.now + (60*60*4.5), story_id: 1234 }).save!
            Activity.create({ user_id: '1', activity_type: 'dashboard#discussion', created_at: Time.now + (60*60*4), story_id: 1234 }).save!
        end
        it "returns a float" do
            retVal = Activity.discuss_time(1234)
            expect(retVal.is_a?(Float)).to be true
        end
        it "returns the correct value" do
            retVal = Activity.discuss_time(1234)
            expect((retVal - 1.5*60).abs <= 0.1).to be true
        end
    end

    context "#vote_variance" do
        before do
            Activity.create({ user_id: '1', activity_type: 'dashboard#vote', created_at: Time.now, story_id: 1234, activity_data: {story_id: 1234, vote: 3, user: '1'}.to_json }).save!
            Activity.create({ user_id: '1', activity_type: 'dashboard#vote', created_at: Time.now, story_id: 1234, activity_data: {story_id: 1234, vote: 3, user: '1'}.to_json }).save!
            Activity.create({ user_id: '1', activity_type: 'dashboard#vote', created_at: Time.now, story_id: 1234, activity_data: {story_id: 1234, vote: 1, user: '1'}.to_json }).save!
            Activity.create({ user_id: '1', activity_type: 'dashboard#vote', created_at: Time.now, story_id: 1234, activity_data: {story_id: 1234, vote: 1, user: '1'}.to_json }).save!
            Activity.create({ user_id: '1', activity_type: 'dashboard#vote', created_at: Time.now, story_id: 1234, activity_data: {story_id: 1234, vote: 2, user: '1'}.to_json }).save!
            Activity.create({ user_id: '1', activity_type: 'dashboard#vote', created_at: Time.now, story_id: 1234, activity_data: {story_id: 1234, vote: 1, user: '1'}.to_json }).save!
        end
        it "returns a float" do
            retVal = Activity.vote_variance(1234)
            expect(retVal.is_a?(Float)).to be true
        end

        it "returns the correct value" do
            retVal = Activity.vote_variance(1234)
            expect((retVal - 0.89752746785575).abs <= 0.05).to be true
        end
    end

    context "#updated_by" do
        before do
            Activity.create({ user_id: '765', activity_type: 'dashboard#update', created_at: Time.now, story_id: 1234 }).save!
            Activity.create({ user_id: '763', activity_type: 'dashboard#update', created_at: Time.now, story_id: 1234 }).save!
            Activity.create({ user_id: '765', activity_type: 'dashboard#update', created_at: Time.now + (60*60*3), story_id: 1234 }).save!
            u1 = User.new(username: 'user1@example.com', password: 'pass1', token: 't1', id: 765)
            u1.save
        end
        it "returns a string" do
            retVal = Activity.updated_by(1234)
            expect(retVal.is_a?(String)).to be true
        end
        it "returns the correct" do
            retVal = Activity.updated_by(1234)
            assert_equal retVal, "user1@example.com"
        end
    end
end
