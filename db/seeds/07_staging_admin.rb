User.find_or_create_by!(email: "hamzis.systems@gmail.com") do |user|
  user.password = "Hamzis12345!"
  user.role = "admin"
end

puts "✅ Staging admin user seeded!"
