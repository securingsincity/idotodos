defmodule IdotodosEx.Repo.Migrations.AddImagesToWebsite do
  use Ecto.Migration

  def change do
   alter table(:websites) do
      add :images, :map
      add :show_gallery, :boolean
      add :bridal_party, :map
      add :show_bridal_party, :boolean
      add :show_rsvp, :boolean
    end
  end
end
