defmodule IdotodosEx.CampaignRegistry do
  use IdotodosEx.Web, :model

  schema "campaign_registries" do
    field :link, :string
    field :name, :string
    field :description, :string
    belongs_to :campaign, IdotodosEx.Campaign
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:link, :name, :description, :campaign_id])
    |> validate_required([:link, :name, :description])
  end
end
