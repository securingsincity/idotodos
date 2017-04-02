defmodule IdotodosEx.GuestInviteStatus do
  use IdotodosEx.Web, :model

  schema "guest_invite_statuses" do
    field :attending, :boolean, default: false
    field :allergies, :string
    field :song_requests, :string
    field :shuttle, :boolean, default: false
    field :responded, :boolean, default: false
    field :meal_choice, :string
    belongs_to :party, IdotodosEx.Party
    belongs_to :campaign, IdotodosEx.Campaign
    belongs_to :guest, IdotodosEx.Guest
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :attending,
      :allergies,
      :song_requests,
      :meal_choice,
      :shuttle,
      :responded,
      :party_id,
      :campaign_id,
      :guest_id])
    |> validate_required([:party_id,
    :campaign_id, :guest_id, :attending])
  end

end