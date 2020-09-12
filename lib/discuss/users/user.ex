defmodule Discuss.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :provider, :string
    field :username, :string
    field :email, :string
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :provider, :email])
    |> validate_required([:username, :provider, :email])
  end
end
