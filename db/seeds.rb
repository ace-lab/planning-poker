# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

tnow = Time.now

u1 = User.new(username: 'user1@example.com', password: 'pass1', token: 't1')
u1.save
u2 = User.new(username: 'user2@example.com', password: 'pass2', token: 't2')
u2.save
u3 = User.new(username: 'user3@example.com', password: 'pass3', token: 't3')
u3.save

#------------------------- Story 1 ----------------------------%
Activity.create(story_id: 1, user: u1, activity_type: 'dashboard#detail', created_at: tnow)
Activity.create(
    story_id: 1,
    user: u1,
    activity_type: 'dashboard#vote',
    created_at: tnow + 6.minutes,
    activity_data: {
        'vote' => 1,
    }.to_json
)
Activity.create(story_id: 1, user: u1, activity_type: 'dashboard#select', created_at: tnow + 7.minutes)
Activity.create(story_id: 1, user: u1, activity_type: 'dashboard#update', created_at: tnow + 7.minutes+10.seconds)

Activity.create(story_id: 1, user: u2, activity_type: 'dashboard#detail', created_at: tnow + 1.minute)
Activity.create(
    story_id: 1,
    user: u2,
    activity_type: 'dashboard#vote',
    created_at: tnow + 6.minutes + 30.seconds,
    activity_data: {
        'vote' => 3,
    }.to_json
)

Activity.create(story_id: 1, user: u3, activity_type: 'dashboard#detail', created_at: tnow + 2.minute)
Activity.create(
    story_id: 1,
    user: u3,
    activity_type: 'dashboard#vote',
    created_at: tnow + 6.minutes + 10.seconds,
    activity_data: {
        'vote' => 3,
    }.to_json
)

#------------------------- Story 2 ----------------------------%
Activity.create(story_id: 2, user: u1, activity_type: 'dashboard#detail', created_at: tnow)
Activity.create(
    story_id: 2,
    user: u1,
    activity_type: 'dashboard#vote',
    created_at: tnow + 16.minutes,
    activity_data: {
        'vote' => 2,
    }.to_json
)

Activity.create(story_id: 2, user: u2, activity_type: 'dashboard#detail', created_at: tnow + 1.minute)
Activity.create(
    story_id: 2,
    user: u2,
    activity_type: 'dashboard#vote',
    created_at: tnow + 16.minutes + 30.seconds,
    activity_data: {
        'vote' => 3,
    }.to_json
)
Activity.create(story_id: 2, user: u2, activity_type: 'dashboard#select', created_at: tnow + 17.minutes)
Activity.create(story_id: 2, user: u2, activity_type: 'dashboard#update', created_at: tnow + 17.minutes+10.seconds)

Activity.create(story_id: 2, user: u3, activity_type: 'dashboard#detail', created_at: tnow + 2.minute)
Activity.create(
    story_id: 2,
    user: u3,
    activity_type: 'dashboard#vote',
    created_at: tnow + 16.minutes + 10.seconds,
    activity_data: {
        'vote' => 2,
    }.to_json
)

