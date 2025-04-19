class AddDifferentKindOfVariablesToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :active, :boolean, default: false
    add_column :projects, :start_date, :date
    add_column :projects, :end_date, :datetime
    add_column :projects, :budget, :decimal, precision: 10, scale: 2
    add_column :projects, :priority, :integer
    add_column :projects, :status, :string, default: "draft"
  end
end
