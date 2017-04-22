defmodule IdotodosEx.Schema.Types do
  use Absinthe.Schema.Notation
  alias IdotodosEx.Repo
  object :campaign do
    field :id, :id
    field :name, :string
    field :user, :user
    field :partner, :user
    field :parties, list_of(:party)
    # field :main_date, :date
  end
  object :party do
    field :id, :id
    field :max_party_size, :integer
    field :name, :string
    field :guests, list_of(:guest) do
      resolve fn party, _, _ ->
        guests =
          party
          |> Ecto.assoc(:guests)
          |> Repo.all

        {:ok, guests}
      end
    end
  end

  object :guest do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
  end

  object :user do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
  end
end