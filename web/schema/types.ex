defmodule IdotodosEx.Schema.Types do
  use Absinthe.Schema.Notation
  alias IdotodosEx.{
    Repo, Campaign, Party, GuestInviteStatus, Guest
  }
  object :campaign do
    field :id, :id
    field :name, :string
    field :user, :user
    field :partner, :user
    field :parties, list_of(:party)
    field :guests, list_of(:guest)
    # field :registries, list_of(:registries)
    field :website, :website
    field :invites, list_of(:invite)
    field :main_date, :string
  end

  object :guest_invite_status do
    field :attending, :boolean
    field :allergies, :string
    field :song_requests, :string
    field :shuttle, :boolean
    field :responded, :boolean
    field :meal_choice, :string
  end

  object :invite do
    field :name, :string
    field :type, :string
    field :from, :string
    field :html, :string
    field :email_text, :string
    field :subject, :string
  end

  object :website do
    field :active, :boolean
    field :site_private, :boolean
    field :story, :string
    field :theme, :string
    field :images, :images do
      resolve fn website, _,_ ->
        {:ok, website.images}
      end
    end
    field :show_gallery, :boolean
    field :show_bridal_party, :boolean
    field :show_rsvp, :boolean
    field :show_registry, :boolean
    field :campaign, :campaign do
      resolve fn parent, _,_ ->
        batch({IdotodosEx.Schema.Helpers, :by_id, Campaign}, parent.campaign_id, fn batch_results ->
          {:ok, Map.get(batch_results, parent.campaign_id)}
        end)
      end
    end
    # field :info, :json
  end

  scalar :json do
    parse fn input ->
      case Poison.decode(input.value) do
        {:ok, result} -> result
        _ -> :error
      end
    end

    serialize &Poison.encode!/1
  end

  object :images do
    field :rsvp, :string do
      resolve fn images, _,_ ->
        {:ok, images["rsvp"]}
      end
    end
    field :registry, :string do
      resolve fn images, _,_ ->
        {:ok, images["registry"]}
      end
    end
    field :our_story, :string do
      resolve fn images, _,_ ->
        {:ok, images["our_story"]}
      end
    end
    field :main, :string do
      resolve fn images, _,_ ->
        {:ok, images["main"]}
      end
    end
    field :gallery, list_of(:gallery_image) do
      resolve fn images, _,_ ->
        {:ok, images["gallery"]}
      end
    end
  end

  object :gallery_image do
    field :thumb, :string do
      resolve fn images, _,_ ->
        {:ok, images["thumb"]}
      end
    end
    field :image, :string do
      resolve fn images, _,_ ->
        {:ok, images["image"]}
      end
    end
  end

  object :party do
    field :id, :id
    field :max_party_size, :integer
    field :name, :string
    field :campaign, :campaign do
      resolve fn parent, _,_ ->
        batch({IdotodosEx.Schema.Helpers, :by_id, Campaign}, parent.campaign_id, fn batch_results ->
          {:ok, Map.get(batch_results, parent.campaign_id)}
        end)
      end
    end
    field :guests, list_of(:guest) do
      resolve fn parent, _, _ ->
        batch({IdotodosEx.Schema.Helpers, :has_many_from_party, Guest}, parent.id, fn batch_results ->
          {:ok, Map.get(batch_results, parent.id)}
        end)
      end
    end
  end

  object :guest do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :invite_statuses, list_of(:guest_invite_status) do
      resolve fn parent, _, _ ->
        batch({IdotodosEx.Schema.Helpers, :has_many_from_guest, GuestInviteStatus}, parent.id, fn batch_results ->
          {:ok, Map.get(batch_results, parent.id)}
        end)
      end
    end
    field :party, :party do
      resolve fn parent, _,_ ->
        batch({IdotodosEx.Schema.Helpers, :by_id, Party}, parent.party_id, fn batch_results ->
          {:ok, Map.get(batch_results, parent.party_id)}
        end)
      end
    end
    field :campaign, :campaign do
      resolve fn parent, _,_ ->
        batch({IdotodosEx.Schema.Helpers, :by_id, Campaign}, parent.campaign_id, fn batch_results ->
          {:ok, Map.get(batch_results, parent.campaign_id)}
        end)
      end
    end
  end

  object :user do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :campaign, :campaign do
      resolve fn parent, _,_ ->
        batch({IdotodosEx.Schema.Helpers, :by_id, Campaign}, parent.campaign_id, fn batch_results ->
          {:ok, Map.get(batch_results, parent.campaign_id)}
        end)
      end
    end
  end
end