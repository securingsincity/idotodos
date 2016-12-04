defmodule IdotodosEx.Website do
  use IdotodosEx.Web, :model

  schema "websites" do
    field :active, :boolean, default: false
    field :site_private, :boolean, default: false
    belongs_to :campaign, IdotodosEx.Campaign
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:active, :campaign_id, :site_private])
    |> validate_required([:active, :site_private])
  end
end
