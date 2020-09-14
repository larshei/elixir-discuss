defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  def init(_ret) do

  end

  def call(conn, _ret) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "Need to be logged in")
      |> redirect(to: DiscussWeb.Router.Helpers.topic_path(conn, :index))
      |> halt()
    end
  end
end
