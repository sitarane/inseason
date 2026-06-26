# Cleanup existing data to allow for repeatable seeding
puts "Cleaning database..."
Vouch.destroy_all
Season.destroy_all
Link.destroy_all
Produce.destroy_all
User.destroy_all

puts "Creating users..."
# The Admin user
admin = User.new(email: 'julienboyer@posteo.com', password: 'password')
admin.skip_confirmation!
admin.save!

# A pool of 30 voters to allow for complex score testing
voters = (1..30).map do |i|
  u = User.new(email: "voter#{i}@example.com", password: 'password')
  u.skip_confirmation!
  u.save!
  u
end

puts "Creating produces..."

apple = Produce.create!(name: 'Apple', user: admin, slug: 'apple')
if File.exist?('test/fixtures/files/apple.jpg')
  apple.picture.attach(io: File.open('test/fixtures/files/apple.jpg'), filename: 'apple.jpg', content_type: 'image/jpeg')
end

strawberry = Produce.create!(name: 'Strawberry', user: admin, slug: 'strawberry')
if File.exist?('test/fixtures/files/strawberry.jpg')
  strawberry.picture.attach(io: File.open('test/fixtures/files/strawberry.jpg'), filename: 'strawberry.jpg', content_type: 'image/jpeg')
end

blueberry = Produce.create!(name: 'Blueberry', user: admin, slug: 'blueberry')
if File.exist?('test/fixtures/files/blueberry.jpg')
  blueberry.picture.attach(io: File.open('test/fixtures/files/blueberry.jpg'), filename: 'blueberry.jpg', content_type: 'image/jpeg')
end

peach = Produce.create!(name: 'Peach', user: admin, slug: 'peach')
if File.exist?('test/fixtures/files/peach.jpg')
  peach.picture.attach(io: File.open('test/fixtures/files/peach.jpg'), filename: 'peach.jpg', content_type: 'image/jpeg')
end

cherry = Produce.create!(name: 'Cherry', user: admin, slug: 'cherry')
if File.exist?('test/fixtures/files/cherry.jpg')
  cherry.picture.attach(io: File.open('test/fixtures/files/cherry.jpg'), filename: 'cherry.jpg', content_type: 'image/jpeg')
end

puts "Creating seasons and vouches..."

# 1. The "Confirmed" Season (High score > 10)
apple_season = Season.create!(
  produce: apple,
  user: admin,
  latitude: 52.0, # Berlin
  longitude: 13.0,
  start_time: 130, # May
  end_time: 180    # June
)
voters.first(15).each { |v| Vouch.create!(season: apple_season, user: v, value: true) }

# 2. The "Unconfirmed" Season (Low score)
strawberry_season = Season.create!(
  produce: strawberry,
  user: admin,
  latitude: 52.0, # Berlin
  longitude: 13.0,
  start_time: 160, # June
  end_time: 190    # July
)
voters[15..17].each { |v| Vouch.create!(season: strawberry_season, user: v, value: true) }
voters[18..20].each { |v| Vouch.create!(season: strawberry_season, user: v, value: false) }

# 3. The "Negative" Season (Very bad score)
blueberry_season = Season.create!(
  produce: blueberry,
  user: voters.first,
  latitude: 52.0, # Berlin
  longitude: 13.0,
  start_time: 280, # October
  end_time: 310    # November
)
voters[21..23].each do |v| 
  Vouch.create!(season: blueberry_season, user: v, value: false) 
end

# 4. The "Southern Hemisphere" Season (Summer in Dec/Jan)
peach_season = Season.create!(
  produce: peach,
  user: voters.second,
  latitude: -21.0, # Reunion
  longitude: 55.5,
  start_time: 350, # December
  end_time: 30    # February
)
voters[24..26].each { |v| Vouch.create!(season: peach_season, user: v, value: true) }

# 5. The "Short" Season
cherry_season = Season.create!(
  produce: cherry,
  user: voters.first,
  latitude: 52.0, # Berlin
  longitude: 13.0,
  start_time: 120, # May
  end_time: 125    # May (very short)
)

puts "Adding links..."
[apple, strawberry, blueberry, peach, cherry].each do |p|
  Link.create!(produce: p, from: :wikipedia, url: "https://en.wikipedia.org/wiki/#{p.slug}")
end

puts "Seeding complete!"
