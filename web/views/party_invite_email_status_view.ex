defmodule IdotodosEx.PartyInviteEmailStatusView do
    use IdotodosEx.Web, :view

    @attributes [:event, :reason, :description, :timestamp, :url, :campaign_id]

    def render("show.json", %{data: model}) do
        model
        |> Map.take(@attributes)
    end
end