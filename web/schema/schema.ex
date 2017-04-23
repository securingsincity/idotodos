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

    @desc "Get a user of the site"
    field :users, type: list_of(:user) do
      resolve &IdotodosEx.UserResolver.all/2
    end
  end

  mutation do
    @desc "Create a party with guests"
    field :create_party, type: :party do
      arg :max_party_size, non_null(:integer)
      arg :name, non_null(:string)
      arg :guests, list_of(:guest_input)
      resolve &IdotodosEx.PartyResolver.create/2
    end

    @desc "Update a party with guests - can't a remove a guest from this kind of relation'"
    field :update_party, type: :party do
      arg :id, non_null(:id)
      arg :max_party_size, non_null(:integer)
      arg :name, non_null(:string)
      arg :guests, list_of(:guest_input)
      resolve &IdotodosEx.PartyResolver.update/2
    end



    # @todo "Remove guest"
    # @todo "Remove party"
    # @todo manage invites
    # @todo manage registries
    # @todo update the website?
  end
end