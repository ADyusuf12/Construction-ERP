namespace :db do
  desc "Drop, create, migrate, load Solid Queue schema, and seed"
  task reset_and_seed: :environment do
    puts "Dropping database..."
    Rake::Task["db:drop"].invoke

    puts "Creating database..."
    Rake::Task["db:create"].invoke

    puts "Running migrations..."
    Rake::Task["db:migrate"].invoke

    puts "Loading Solid Queue schema..."
    system("bin/rails runner \"load Rails.root.join('db/queue_schema.rb')\"")

    puts "Seeding..."
    Rake::Task["db:seed"].invoke

    puts "✅ Reset and seeding complete!"
  end
end
