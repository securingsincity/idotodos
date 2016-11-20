defmodule IdotodosEx.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :password, :string
      add :password_reset_token, :string
      add :password_reset_expires, :date
      add :middle_name, :string
      add :gender, :string
      add :street, :string
      add :suite, :string
      add :city, :string
      add :state, :string
      add :zip_code, :string
      add :campaignId, :integer

      timestamps()
    end

  end
end
