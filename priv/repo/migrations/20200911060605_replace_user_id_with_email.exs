defmodule Discuss.Repo.Migrations.ReplaceUserIdWithEmail do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :uid
      add :email, :string
    end
  end
end
