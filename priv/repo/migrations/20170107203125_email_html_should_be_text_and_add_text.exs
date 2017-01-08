defmodule IdotodosEx.Repo.Migrations.EmailHtmlShouldBeTextAndAddText do
  use Ecto.Migration

  def change do
    alter table(:invites) do
      modify :html, :text
      add :email_text, :text
    end
  end
end
