defmodule IdotodosEx.UserResolver do
  alias IdotodosEx.User
  def all(_args, _info) do
    {:ok, IdotodosEx.Repo.all(User)}
  end

  def find(%{id: id}, _info) do
    case IdotodosEx.Repo.get(User, id) do
      nil  -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end
end