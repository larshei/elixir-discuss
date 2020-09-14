defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics, as: DT

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_user_is_topic_owner when action in [:edit, :update, :delete]

  # ======================================================
  def index(conn, _param) do
    IO.inspect(conn.assigns)
    topics = DT.list_topics()
    render conn, "index.html", topics: topics
  end

  def show(conn, %{"id" => topic_id}) do
    topic = DT.get_topic!(topic_id)
    render conn, "show.html", topic: topic
  end
  # ======================================================
  def new(conn, _params) do
    changeset = DT.Topic.changeset(%DT.Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = conn.assigns.user
    |> Ecto.build_assoc(:topics)
    |> DT.Topic.changeset(topic)

    case Discuss.Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Created Topic \"#{post.title}\"")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end
  # ======================================================
  def edit(conn, %{"id" => topic_id}) do
    topic = DT.get_topic!(topic_id)
    changeset = DT.Topic.changeset(topic, %{})
    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = DT.get_topic!(topic_id)
    result = DT.update_topic(old_topic, topic)

    case result do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Updated \"#{post.title}\"")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid Title")
        |> redirect(to: Routes.topic_path(conn, :edit, old_topic))
    end
  end
  # ======================================================

  def delete(conn, %{"id" => topic_id}) do
    topic = DT.get_topic!(topic_id)
    IO.inspect(topic)
    result = DT.delete_topic(topic)
    IO.inspect(result)

    conn
    |> put_flash(:info, "Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end
  # ==================== PLUGS =========================
  def check_user_is_topic_owner(conn, _plugparams) do
    %{params: %{"id" => topic_id}} = conn

    topic = DT.Topic.get_topic!(topic_id)
    if topic.user_id == conn.assigns.user.id do
        conn
    else
        conn
        |> put_flash(:error, "You do not have permission to do this")
        |> redirect(to: Routes.topic_path(conn, :index))
        |> halt()
    end
  end
end
