defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller

  alias Discuss.Users, as: DU
  alias Discuss.Repo

  plug Ueberauth

  def callback(conn, param) do #ueberauth requires `callback` to be implemented
    %{assigns: %{ueberauth_auth: auth}} = conn
    # %{assigns: %{ueberauth_auth: %{info: %{nickname: user_name}}}} = conn
    # %{assigns: %{ueberauth_auth: %{provider: auth_provider, uid: user_id}}} = conn
    user_info = %{username: auth.info.nickname, provider: Atom.to_string(auth.provider), email: auth.info.email}
    changeset = DU.User.changeset(%DU.User{}, user_info)
    signin(conn,changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Logged in")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Could not sign you in, sorry")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  def signout(conn, _param) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp insert_or_update_user(changeset) do
    IO.inspect(changeset)
    case Repo.get_by(DU.User, email: changeset.changes.email) do
      nil -> Repo.insert(changeset)
      user -> {:ok, user}
    end
  end
end
