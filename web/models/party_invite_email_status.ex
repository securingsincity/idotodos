defmodule IdotodosEx.PartyInviteEmailStatus do
  use IdotodosEx.Web, :model
  
  schema "party_invite_email_statuses" do
    field :event, :string
    field :reason, :string
    field :description, :string
    field :recipient, :string
    field :timestamp, :string
    field :url, :string
    belongs_to :campaign, IdotodosEx.Campaign
    belongs_to :party, IdotodosEx.Party
    belongs_to :invite, IdotodosEx.Invite
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :event,
      :reason,
      :description,
      :recipient,
      :timestamp,
      :url,
      :campaign_id,
      :party_id,
      :invite_id
    ])
    |> validate_required([:event, :reason, :description, :recipient, :timestamp, :url])
    |> foreign_key_constraint(:campaign_id)
    |> foreign_key_constraint(:party_id)
    |> foreign_key_constraint(:invite_id)
  end
end
