puts "Starting database seeding..."

if Rails.env.development? || Rails.env.production?
  Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |file|
    puts "Loading #{File.basename(file)}..."
    load(file)
  end
  puts "✅ Seeding complete!"
else
  puts "Skipping seeds in #{Rails.env} environment."
end
