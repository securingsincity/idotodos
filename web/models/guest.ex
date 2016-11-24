defmodule IdotodosEx.Guest do
  use IdotodosEx.Web, :model

  schema "guests" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    
    field :middle_name, :string
    field :gender, :string
    field :street, :string
    field :suite, :string
    field :city, :string
    field :state, :string
    field :zip_code, :string
    belongs_to :campaign, IdotodosEx.Campaign
    belongs_to :party, IdotodosEx.Party
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:campaign_id, :party_id, :first_name, :last_name, :email, :middle_name, :gender, :street, :suite, :city, :state, :zip_code])
    |> validate_required([:first_name, :last_name])
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/)
  end

  def changeset_with_party(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:campaign_id, :party_id])
    |> cast_assoc(:party)
    |> cast_assoc(:campaign)
  end
end
