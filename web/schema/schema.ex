defmodule IdotodosEx.Schema do
  use Absinthe.Schema
  import_types IdotodosEx.Schema.Types

  query do
    @desc "Get a list of campaigns"
    field :campaigns, list_of(:campaign) do
      resolve &IdotodosEx.CampaignResolver.all/2
    end
    @desc "Get a campaign by Id"
    field :campaign, type: :campaign do
      arg :id, non_null(:id)
      resolve &IdotodosEx.CampaignResolver.find/2
    end

    @desc "Get a user of the site"
    field :user, type: :user do
      arg :id, non_null(:id)
      resolve &IdotodosEx.UserResolver.find/2
    end
  end
end