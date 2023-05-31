defmodule StradaleWeb.Router do
  use StradaleWeb, :router

  import StradaleWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {StradaleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", StradaleWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:stradale, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: StradaleWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", StradaleWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{StradaleWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", StradaleWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{StradaleWeb.UserAuth, :ensure_authenticated}] do

      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/inventories", InventoryLive.Index, :index
      live "/inventories/new", InventoryLive.Index, :new
      live "/inventories/:id/edit", InventoryLive.Index, :edit

      live "/inventories/:id", InventoryLive.Show, :show
      live "/inventories/:id/show/edit", InventoryLive.Show, :edit

      live "/clients", ClientLive.Index, :index
      live "/clients/new", ClientLive.Index, :new
      live "/clients/:id/edit", ClientLive.Index, :edit

      live "/clients/:id", ClientLive.Show, :show
      live "/clients/:id/show/edit", ClientLive.Show, :edit

      live "/", GarageLive.Index, :index
      live "/garages", GarageLive.Index, :index
      live "/garages/new", GarageLive.Index, :new
      live "/garages/:id/edit", GarageLive.Index, :edit

      live "/garages/:id", GarageLive.Show, :show
      live "/garages/:id/show/edit", GarageLive.Show, :edit
    end
  end

  scope "/", StradaleWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{StradaleWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
