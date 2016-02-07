defmodule Cataract.Router do
  use Cataract.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", Cataract do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show

    get "/transfers", TransferController, :index

    get "/ember", EmberController, :index
  end

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  # Other scopes may use custom stacks.
  scope "/api/1", Cataract do
    pipe_through :api
    get "/transfers", TransferController, :index
    resources "/disks", DiskController
  end
end
