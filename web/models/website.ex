defmodule IdotodosEx.Website do
  use IdotodosEx.Web,
   :model

  schema "websites" do
    field :active, :boolean, default: false
    field :site_private, :boolean, default: false
    field :story, :string
    field :images, :map
    field :theme, :string, default: "cambridge"
    field :bridal_party, :map
    field :info, :map
    field :show_gallery, :boolean, default: false
    field :show_bridal_party, :boolean, default: false
    field :show_rsvp, :boolean, default: false
    field :show_registry, :boolean, default: false
    belongs_to :campaign, IdotodosEx.Campaign
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :active,
      :campaign_id,
      :site_private,
      :theme,
      :story,
      :images,
      :info,
      :show_rsvp,
      :show_gallery,
      :show_registry,
      :show_bridal_party,
      :bridal_party
    ])
    |> validate_required([:active,
     :site_private])
  end
end
