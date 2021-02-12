defmodule ClassicClips.Timeline.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias ClassicClips.Timeline.User
  alias ClassicClips.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :active, :boolean, default: false
    field :email, :string
    field :username, :string
    field :google_id, :string

    timestamps()
  end

  def create_user(attrs) do
    changeset(%User{}, attrs)
    |> Repo.insert(returning: true)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :active, :google_id])
    |> put_change(:google_id, user.google_id || attrs.sub)
    |> validate_required([:email])
    |> validate_format(:username, ~r/^[\S]+$/, message: "Username may not contain spaces")
    |> unique_constraint(:email, message: "This email is being used by another account")
    |> unique_constraint(:google_id,
      message: "This Google Account is already associated with another account"
    )
    |> unsafe_validate_unique(:username, Repo, message: "Username is already taken")
  end
end
