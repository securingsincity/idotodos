defmodule IdotodosEx.Invite do
  use IdotodosEx.Web, :model

  schema "invites" do
    field :name, :string
    field :type, :string
    field :from, :string
    field :html, :string
    field :email_text, :string
    field :subject, :string
    belongs_to :campaign, IdotodosEx.Campaign
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :type, :html, :subject, :email_text, :campaign_id])
    |> validate_required([:name, :type, :html, :subject])
  end

  def changeset_with_campaign(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast_assoc(:campaign)
  end
end
