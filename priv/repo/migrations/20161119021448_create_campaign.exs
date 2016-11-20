defmodule IdotodosEx.Repo.Migrations.CreateCampaign do
  use Ecto.Migration

  def change do
    create table(:campaigns) do
      add :userId, :integer
      add :partnerId, :integer
      add :main_date, :date
      add :name, :string

      timestamps()
    end

  end
end
