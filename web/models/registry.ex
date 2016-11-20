defmodule IdotodosEx.Registry do
  use IdotodosEx.Web, :model

  schema "registries" do
    field :image, :string
    field :link, :string
    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:image, :link, :name, :description])
    |> validate_required([:image, :link, :name, :description])
  end
end
