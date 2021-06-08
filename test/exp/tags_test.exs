defmodule Exp.TagsTest do
  use Exp.DataCase

  alias Exp.Tags

  describe "tags" do
    alias Exp.Tags.Tag

    @valid_attrs %{name: "some name", type: "income"}
    @update_attrs %{name: "some updated name", type: "expense"}
    @invalid_attrs %{name: nil, type: nil}

    def tag_fixture(attrs \\ %{}) do
      user = Exp.AccountsFixtures.user_fixture()
      attrs = Enum.into(attrs, @valid_attrs)

      {:ok, tag} = Tags.create_tag(user, attrs)

      tag
    end

    test "list user tags" do
      user = Exp.AccountsFixtures.user_fixture()
      {:ok, expense_tag} = Tags.create_tag(user, %{name: "Food", type: "expense"})
      {:ok, income_tag} = Tags.create_tag(user, %{name: "Salary", type: "income"})

      assert Tags.list_tags(user) == [expense_tag, income_tag]
    end

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Tags.list_tags() == [tag]
    end

    test "list user's expense tags" do
      user = Exp.AccountsFixtures.user_fixture()
      {:ok, expense_tag} = Tags.create_tag(user, %{name: "Food", type: "expense"})
      {:ok, _income_tag} = Tags.create_tag(user, %{name: "Salary", type: "income"})

      assert Tags.list_expenses_tags(user) == [expense_tag]
    end

    test "list user's income tags" do
      user = Exp.AccountsFixtures.user_fixture()
      {:ok, _expense_tag} = Tags.create_tag(user, %{name: "Food", type: "expense"})
      {:ok, income_tag} = Tags.create_tag(user, %{name: "Salary", type: "income"})

      assert Tags.list_income_tags(user) == [income_tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Tags.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      user = Exp.AccountsFixtures.user_fixture()
      assert {:ok, %Tag{} = tag} = Tags.create_tag(user, @valid_attrs)
      assert tag.name == "some name"
      assert tag.type == "income"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      user = Exp.AccountsFixtures.user_fixture()
      assert {:error, %Ecto.Changeset{}} = Tags.create_tag(user, @invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{} = tag} = Tags.update_tag(tag, @update_attrs)
      assert tag.name == "some updated name"
      assert tag.type == "expense"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Tags.update_tag(tag, @invalid_attrs)
      assert tag == Tags.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Tags.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Tags.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Tags.change_tag(tag)
    end
  end
end
