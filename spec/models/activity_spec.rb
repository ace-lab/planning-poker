require 'spec_helper'

RSpec.describe Activity, type: :model do

  describe 'self.infer_meetings' do
    before :each do
      t = Time.now
      FactoryBot.create(:activity, created_at: t)
      FactoryBot.create(:activity, created_at: t+1.minute)
      FactoryBot.create(:activity, created_at: t+1.hour+2.minute)
    end
    it 'groups activities together' do
      expect(Activity.infer_meetings.length).to eql(2)
    end

    it 'divides activities correctly' do
      meetings = Activity.infer_meetings
      expect(meetings[0].length).to eql(2)
      expect(meetings[1].length).to eql(1)
    end
  end
end
