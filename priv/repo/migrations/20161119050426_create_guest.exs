defmodule IdotodosEx.Repo.Migrations.CreateGuest do
  use Ecto.Migration

  def change do
    create table(:guests) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :password, :string
      add :party_id, :integer
      add :middle_name, :string
      add :gender, :string
      add :street, :string
      add :suite, :string
      add :city, :string
      add :state, :string
      add :zip_code, :string
      add :campaign_id, :integer

      timestamps()
    end

  end
end
