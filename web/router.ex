defmodule IdotodosEx.Router do
  use IdotodosEx.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated, handler: IdotodosEx.Token
    plug Guardian.Plug.LoadResource
  end
  pipeline :browser_admin do
    plug IdotodosEx.Plugs.IsAdmin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :mailgun do
    plug :accepts, ["html"]
    # add a mailgun webhook plug
  end

  scope "/", IdotodosEx do
    pipe_through :browser # Use the default browser stack
    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/signin", SessionController, :new
    post "/signin", SessionController, :create
    get "/signout", SessionController, :delete
    get "/signup", RegistrationController, :signup
    post "/signup", RegistrationController, :create
  end
  scope "/", IdotodosEx do
    pipe_through :browser
    get "/wedding/:name", WeddingController, :index
    post "/wedding/:name", WeddingController, :sign_in
    delete "/wedding/:name", WeddingController, :sign_out
  end

  scope "/", IdotodosEx do
    pipe_through :mailgun
    post "/party-invite-email-status", PartyInviteEmailStatusController, :create
  end

  scope "/", IdotodosEx do
    pipe_through [:browser, :browser_auth]
    get "/app", PageController, :app
    get "/app/parties/upload", PartyController, :upload
    post "/app/parties/upload", PartyController, :bulk_upload
    get "/app/parties-download-template", PartyController, :download_template
    resources "/users", UserController
    get "/app/parties/:id/add-guest", UserPartyController, :add_guest
    get "/app/parties/:id/email-statuses", UserPartyController, :email_status_index
    resources "/app/parties", UserPartyController
    resources "/app/invites", UserInviteController
    get "/app/invites/:id/send", UserInviteController, :send
    post "/app/invites/:id/send", UserInviteController, :send_email
    get "/app/website", UserWebsiteController, :edit
    post "/app/website", UserWebsiteController, :update
    put "/app/website", UserWebsiteController, :update
    resources "/guests", GuestController
    resources "/parties", PartyController
    resources "/restaurants", RestaurantController
    resources "/things_to_do", ThingToDoController
    resources "/hotels", HotelController
    resources "/campaign_registries", CampaignRegistryController
    resources "/registries", RegistryController
  end

  scope "/api", IdotodosEx do
    pipe_through [:api]
    post "/party-invite-email-status", PartyInviteEmailStatusController, :create

  end

  scope "/admin", IdotodosEx do
    pipe_through [:browser, :browser_auth, :browser_admin]
    resources "/campaigns", CampaignController

  end

end
