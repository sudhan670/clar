puts "🌱 Seeding started..."


users_data = [
  { email: 'admin@example.com', name: 'Admin User', role: 'admin', position: 'admin' },
  { email: 'hr@example.com', name: 'HR Manager', role: 'employee', position: 'hr' },
  { email: 'teamlead@example.com', name: 'Team Lead', role: 'employee', position: 'team_lead' },
  { email: 'senior@example.com', name: 'Senior Employee', role: 'employee', position: 'senior_employee' },
  { email: 'junior@example.com', name: 'Junior Developer', role: 'employee', position: 'junior_developer' },
  { email: 'sudhandurai670@gmail.com', name: 'Sudhaned', role: 'employee', position: 'junior_developer' }
]

users = {}

users_data.each do |data|
  user = User.find_or_initialize_by(email: data[:email])
  user.update!(
    name: data[:name],
    role: data[:role],
    position: data[:position],
    password: 'password123'
  )
  users[data[:email]] = user
end

puts "✅ Users created"


rooms_data = [
  { name: 'Ruby Shell Worker', capacity: 23, description: '' },
  { name: 'New Room Adder', capacity: 12, description: '' }
]

rooms = {}

rooms_data.each do |data|
  room = Room.find_or_initialize_by(name: data[:name])
  room.update!(
    capacity: data[:capacity],
    description: data[:description]
  )
  rooms[data[:name]] = room
end

puts "✅ Rooms created"

# -------------------------------
# BOOKINGS
# -------------------------------
bookings_data = [
  { room: 'Ruby Shell Worker', user: 'admin@example.com', start_time: '2026-04-20 01:30', end_time: '2026-04-20 03:30' },
  { room: 'New Room Adder', user: 'junior@example.com', start_time: '2026-04-19 23:00', end_time: '2026-04-20 01:00' },
  { room: 'New Room Adder', user: 'admin@example.com', start_time: '2026-04-19 15:00', end_time: '2026-04-19 17:00' },
  { room: 'Ruby Shell Worker', user: 'sudhandurai670@gmail.com', start_time: '2026-04-20 02:00', end_time: '2026-04-20 04:00' }
]

bookings = []

bookings_data.each do |data|
  booking = Booking.find_or_initialize_by(
    room: rooms[data[:room]],
    user: users[data[:user]],
    start_time: data[:start_time]
  )

  booking.update!(
    end_time: data[:end_time],
    description: ''
  )

  bookings << booking
end

puts "✅ Bookings created"


participants_data = [
  { booking_index: 0, user: 'senior@example.com', status: 'accepted' },
  { booking_index: 0, user: 'admin@example.com', status: 'accepted' },
  { booking_index: 1, user: 'junior@example.com', status: 'accepted' },
  { booking_index: 2, user: 'sudhandurai670@gmail.com', status: 'accepted' },
  { booking_index: 3, user: 'senior@example.com', status: 'pending' },
  { booking_index: 3, user: 'sudhandurai670@gmail.com', status: 'accepted' }
]

participants_data.each do |data|
  MeetingParticipant.find_or_create_by!(
    booking: bookings[data[:booking_index]],
    user: users[data[:user]]
  ) do |mp|
    mp.status = data[:status]
  end
end

puts "✅ Meeting participants created"

puts "🎉 Seeding completed successfully!"