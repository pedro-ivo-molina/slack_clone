defmodule SlackClone.Rooms.Room do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias SlackClone.Accounts.User

  schema "rooms" do
    field :name, :string
    field :description, :string
    field :invite_code, :string

    belongs_to :user, SlackClone.Accounts.User
    many_to_many :members, User, join_through: "room_members"

    timestamps([{:inserted_at,:created_at}, {:updated_at, false}])
  end

  def changeset(room, attrs, opts \\ []) do
    room
    |> cast(attrs, [:name, :description, :invite_code, :user_id])
    |> validate_required([:name, :description, :user_id])
    |> maybe_generate_invite_token(opts)
  end

  defp maybe_generate_invite_token(changeset, opts) do
    general_invite? = Access.get(opts, :general_invite?, false)

    room_is_new? =
      changeset
      |> get_field(:id)
      |> is_nil()

    if general_invite? or room_is_new? do
      put_change(changeset, :invite_code, random_string(10))
    else
      changeset
    end
  end

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
