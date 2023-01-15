defmodule SlackClone.Rooms do
  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias SlackClone.Accounts
  alias SlackClone.Accounts.User
  alias SlackClone.Repo
  alias SlackClone.Rooms.Room

  def get_user_rooms(%User{} = user) do
    user
    |> Repo.preload(:rooms)
    |> Map.get(:rooms)
  end

  def get_room!(id) do
    Repo.get!(Room, id)
  end

  @spec get_room_by!(any) :: any
  def get_room_by!(param) do
    Repo.get_by!(Room, param)
  end

  def join(user, room) do
    room = Repo.preload(room, :members)

    room
    |> Room.changeset(%{})
    |> put_assoc(:members, [user | room.members])
    |> Repo.update()
  end

  def create_room(attrs) when is_map(attrs) do
    user = Accounts.get_user!(attrs.user_id)

    %Room{}
    |> Room.changeset(attrs)
    |> put_assoc(:members, [user])
    |> Repo.insert()
  end
end
