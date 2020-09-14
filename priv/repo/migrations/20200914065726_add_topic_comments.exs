defmodule Discuss.Repo.Migrations.AddTopicComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
        add :user_id, references(:users)
        add :topic, references(:topics)
        add :text, :string

        timestamps()
    end
  end
end
