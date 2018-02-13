namespace :db do
  desc "Populate database with sample data for development"
  task generate_data: ["db:drop", "db:create", "db:migrate"] do
    puts "Creating users ..."
    5.times do |n|
      User.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        username: "user_#{n+1}",
        email: "user_#{n+1}@email.com",
        password: "password"
      )
    end

    puts "First two users are creating two messages each ..."
    User.first(2).each do |user|
      2.times {user.create_message Faker::Lorem.sentence}
    end

    puts "First user is sending: 1st msg to user3, 2nd message to \
[user2, user3] ..."
    User.first.messages.first.add_recipient User.third
    User.first.messages.second.add_recipient User.second, User.third

    puts "Second user is sending: [1st msg, 2nd msg] to user5 ..."
    User.second.messages.each do |message|
      message.add_recipient User.fifth
    end

    puts "Done!"
  end
end
