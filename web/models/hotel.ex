defmodule IdotodosEx.Hotel do
  use IdotodosEx.Web, :model

  schema "hotels" do
    field :address, :string
    field :phone_number, :string
    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:address, :phone_number, :name, :description])
    |> validate_required([:address, :phone_number, :name, :description])
  end
end
