defmodule IdotodosEx.Repo.Migrations.AddThemeToWebsite do
  use Ecto.Migration

  def change do
   alter table(:websites) do
      add :theme, :string
      add :story, :text
    end
  end
end
