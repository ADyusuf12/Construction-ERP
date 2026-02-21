namespace :db do
  desc "Force kill connections, Drop, create, migrate, load Solid Queue, and seed"
  task reset_and_seed: :environment do
    # 1. Kill Active Connections
    puts "💥 Terminating existing database connections..."
    db_name = Rails.configuration.database_configuration[Rails.env]["database"]
    terminate_query = %(psql -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '#{db_name}' AND pid <> pg_backend_pid();")
    system(terminate_query)

    # 2. Standard Reset Flow
    puts "🗑️  Dropping database..."
    Rake::Task["db:drop"].invoke

    puts "🏗️  Creating database..."
    Rake::Task["db:create"].invoke

    puts "📑 Running migrations..."
    Rake::Task["db:migrate"].invoke

    # 3. Specific Infrastructure Setup
    puts "📦 Loading Solid Queue schema..."
    # Note: Using system call because queue_schema is often external to standard migrations
    system("bin/rails runner \"load Rails.root.join('db/queue_schema.rb')\"")

    # 4. Optional: Clean Active Storage (Good for clean filming)
    puts "🖼️  Cleaning Active Storage records..."
    ActiveStorage::Attachment.delete_all
    ActiveStorage::Blob.delete_all

    # 5. Seed the Data
    puts "🌱 Seeding fresh Nigerian ERP data..."
    Rake::Task["db:seed"].invoke

    puts "✅ SUCCESS: Your stage is set for filming!"
  end
end
