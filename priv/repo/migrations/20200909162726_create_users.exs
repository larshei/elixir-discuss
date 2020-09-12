defmodule Discuss.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :provider, :string
      add :uid, :integer

      timestamps()
    end

  end
end
