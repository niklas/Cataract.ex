defmodule Cataract.Router do
  use Cataract.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Cataract do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show

    get "/transfers", TransferController, :index

    get "/ember", EmberController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Cataract do
  #   pipe_through :api
  # end
end
