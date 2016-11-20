defmodule IdotodosEx.Party do
  use IdotodosEx.Web, :model

  schema "parties" do
    field :name, :string
    field :max_party_size, :integer
    belongs_to :campaign, IdotodosEx.Campaign
    # has_many :guests, IdotodosEx.Guest
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [ :name, :max_party_size])
    |> validate_required([:name, :max_party_size])
  end
end
