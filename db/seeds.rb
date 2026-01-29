puts "Starting database seeding..."

Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |file|
  puts "Loading #{File.basename(file)}..."
  load(file)
end

puts "✅ Seeding complete!"
