class RenameManagerRoleToSiteManager < ActiveRecord::Migration[8.0]
  def up
    User.where(role: User.roles[:manager]).update_all(role: User.roles[:site_manager])
  end

  def down
    User.where(role: User.roles[:site_manager]).update_all(role: User.roles[:manager])
  end
end
