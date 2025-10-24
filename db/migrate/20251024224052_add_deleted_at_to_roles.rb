class AddDeletedAtToRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :deleted_at, :datetime
    add_index  :roles, :deleted_at

    # Rebuild unique indexes to apply only to alive rows
    remove_index :roles, :slug        if index_exists?(:roles, :slug, unique: true)
    add_index    :roles, :slug,
                 unique: true,
                 where:  "deleted_at IS NULL",
                 name:   "index_roles_on_slug_alive"

    # Optional: enforce unique role name among alive rows (case-insensitive)
    if index_exists?(:roles, "LOWER(role)", name: "index_roles_on_lower_role_unique")
      remove_index :roles, name: "index_roles_on_lower_role_unique"
    end
    add_index :roles, "LOWER(role)",
              unique: true,
              where:  "deleted_at IS NULL",
              name:   "index_roles_on_lower_role_alive_unique"
  end
end
