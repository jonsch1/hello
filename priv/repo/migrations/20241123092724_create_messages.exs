defmodule Hello.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string, null: false

      timestamps()
    end
  end
end