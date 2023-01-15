defmodule SlackClone.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :description, :text, null: false
      add :invite_code, :string, null: false

      timestamps([{:inserted_at,:created_at}, {:updated_at, false}])
    end

    create unique_index(:rooms, [:user_id, :name])
  end
end
