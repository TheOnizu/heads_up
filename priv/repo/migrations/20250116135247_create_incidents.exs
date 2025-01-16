defmodule HeadsUp.Repo.Migrations.CreateIncidents do
  use Ecto.Migration

  def change do
    create table(:incidents) do
      add :name, :string
      add :description, :text
      add :priority, :integer, default: 1
      add :status, :string, default: "pending"
      add :image_path, :string, default: "/images/placeholder.jpg"

      timestamps(type: :utc_datetime)
    end
  end
end
