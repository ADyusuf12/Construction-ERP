FactoryBot.define do
  factory :report do
    association :project
    association :user

    report_date     { Date.today }
    report_type     { :daily }
    status          { :draft }
    progress_summary { "This is a valid progress summary with more than ten characters." }
    issues          { "No major issues encountered." }
    next_steps      { "Continue with the next phase." }
  end
end
