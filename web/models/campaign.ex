defmodule IdotodosEx.Campaign do
  use IdotodosEx.Web, :model

  schema "campaigns" do
    field :main_date, Ecto.Date
    field :name, :string
    has_one :user, IdotodosEx.User
    has_one :partner, IdotodosEx.User
    has_many :guests, IdotodosEx.Guest
    has_many :parties, IdotodosEx.Party
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [ :main_date, :name])
    |> validate_required([ :main_date, :name])
    |> validate_format(:name, ~r/^([^\\\/][A-z0-9\-\+]+$)/)
  end

  def registration_changeset(struct, params \\ %{}) do 
    struct
    |> changeset(params)
    |> cast_assoc(:partner, required: true, with: &IdotodosEx.User.partner_changeset(&1,&2) )
    |> cast_assoc(:user, required: true, with: &IdotodosEx.User.registration_changeset(&1,&2))
  end

end
