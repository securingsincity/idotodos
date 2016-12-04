defmodule IdotodosEx.Party do
  use IdotodosEx.Web, :model

  schema "parties" do
    field :name, :string
    field :max_party_size, :integer
    belongs_to :campaign, IdotodosEx.Campaign
    has_many :guests, IdotodosEx.Guest
    has_many :party_invite_email_statuses, IdotodosEx.PartyInviteEmailStatus
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [ :name, :max_party_size, :campaign_id])
    |> validate_required([:name, :max_party_size])
  end

  def changeset_with_guests(struct, params) do
    struct
    |> changeset(params)
    |> cast_assoc(:guests)
    |> validate_max_party_size
    |> cast_assoc(:campaign)
  end

  def validate_max_party_size(changeset) do
    guests = get_field(changeset, :guests)
    max_party_size = get_field(changeset, :max_party_size)

    case length(guests) <= max_party_size do
      true -> changeset
      false -> add_error(changeset, :guests, "You can't invite more guests than the max party size")
    end
  end
end
