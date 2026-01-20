class ProjectFile < ApplicationRecord
  belongs_to :project
  has_many_attached :files

  enum :category, {
    architecture: 0,
    contract: 1,
    permit: 2,
    photo: 3,
    other: 4
  }, prefix: true

  validates :category, presence: true
  validate :files_presence
  validate :files_content_type_matches_category

  private

  def files_presence
    errors.add(:files, "must be attached") if files.blank?
  end

  def files_content_type_matches_category
    return if files.blank?

    allowed = {
      "architecture" => %w[application/pdf image/png image/jpeg application/x-autocad],
      "contract"     => %w[application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document],
      "permit"       => %w[application/pdf image/png image/jpeg],
      "photo"        => %w[image/png image/jpeg image/heic],
      "other"        => %w[application/pdf image/png image/jpeg application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.ms-powerpoint]
    }

    allowed_types = allowed[category.to_s] || allowed["other"]

    files.each do |f|
      unless allowed_types.include?(f.content_type)
        errors.add(:files, "contains an invalid file type for #{category.humanize}")
      end
    end
  end
end
