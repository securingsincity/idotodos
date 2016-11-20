defmodule IdotodosEx.AuthConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  alias IdotodosEx.Repo
  alias IdotodosEx.User
  
  
  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias IdotodosEx.Repo
      alias IdotodosEx.User
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import IdotodosEx.Router.Helpers
      
      # The default endpoint for testing
      @endpoint IdotodosEx.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(IdotodosEx.Repo)
    
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(IdotodosEx.Repo, {:shared, self()})
    end
    user_changeset = User.registration_changeset(%User{}, %{first_name: "James", gender: "male", last_name: "Hrisho", email: "james.hrisho@gmail.com", password: "a123123"})
    Repo.insert!(user_changeset)
    user = Repo.get_by!(User, email: "james.hrisho@gmail.com")
    conn = IdotodosEx.AuthHelpers.sign_in(Phoenix.ConnTest.build_conn(), user)
    
    {:ok, conn: conn}
  end
end
