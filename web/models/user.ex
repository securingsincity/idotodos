defmodule IdotodosEx.User do
  use IdotodosEx.Web, :model
  @allowed_fields [
    :first_name,
    :last_name,
    :email,
    :password,
    :middle_name,
    :gender,
    :street,
    :suite,
    :city,
    :state,
    :zip_code
  ]
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirm, :string, virtual: true
    field :password_hash, :string
    field :middle_name, :string
    field :gender, :string
    field :street, :string
    field :suite, :string
    field :city, :string
    field :state, :string
    field :zip_code, :string
    field :is_admin, :boolean
    belongs_to :campaign, IdotodosEx.Campaign
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required([:first_name, :last_name, :email])
    |> put_change(:is_admin, false)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, message: "Password and password confirmation must match")
    |> put_pass_hash()
  end

  def admin_registration_changeset(model, params) do
    model
    |> registration_changeset(params) 
    |> put_change(:is_admin, true)
  end


  def partner_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> put_change(:is_admin, false)
    |> validate_required([:first_name, :last_name])
  end
  
  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
