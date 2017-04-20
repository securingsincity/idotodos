defmodule IdotodosEx.Factories do
  @moduledoc false

  # with Ecto
  use ExMachina.Ecto, repo: IdotodosEx.Repo

  def campaign_factory do
    %IdotodosEx.Campaign{
      main_date: %{day: 17, month: 4, year: 2010},
      name: sequence(:name, &"campaign#{&1}"),
      user: build(:user),
      partner: build(:user),
    }
  end

  def user_factory do
    %IdotodosEx.User{
      first_name: sequence(:first_name, &"First#{&1}"),
      last_name: sequence(:last_name, &"Last#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com"),
    }
  end

  def party_factory do
    %IdotodosEx.Party{
      max_party_size: 2,
      name: sequence(:name, &"Party#{&1}"),
      campaign: build(:campaign)
    }
  end
end