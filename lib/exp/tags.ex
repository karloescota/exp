defmodule Exp.Tags do
  import Ecto.Query, warn: false
  alias Exp.Repo

  alias Exp.Tags.Tag

  def list_tags(user) do
    query = from tag in Tag, where: tag.user_id == ^user.id
    Repo.all(query)
  end

  def list_tags do
    Repo.all(Tag)
  end

  def list_expenses_tags(user) do
    query = from tag in Tag, where: tag.type == "expense" and tag.user_id == ^user.id
    Repo.all(query)
  end

  def get_tag!(id), do: Repo.get!(Tag, id)

  def create_tag(user, attrs \\ %{}) do
    %Tag{user_id: user.id}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end
end
