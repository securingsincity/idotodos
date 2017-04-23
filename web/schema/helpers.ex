defmodule IdotodosEx.Schema.Helpers do
  alias IdotodosEx.Repo
  def by_id(model, ids) do
    import Ecto.Query
    model
    |> where([m], m.id in ^ids)
    |> Repo.all
    |> Map.new(&{&1.id, &1})
  end

  def campaign_by_id(model, ids) do
    import Ecto.Query
    model
    |> where([m], m.id in ^ids)
    |> Repo.all
    |> Repo.preload([:user, :partner, :parties, :website, :guests])
    |> Map.new(&{&1.id, &1})
  end

  def has_many_from_guest(model, ids) do
    import Ecto.Query
    model
    |> where([m], m.guest_id in ^ids)
    |> Repo.all
    |> Enum.group_by(fn storage -> Map.get(storage, :guest_id) end)
  end

  def has_many_from_party(model, ids) do
    import Ecto.Query
    model
    |> where([m], m.party_id in ^ids)
    |> Repo.all
    |> Enum.group_by(fn storage -> Map.get(storage, :party_id) end)
  end

end