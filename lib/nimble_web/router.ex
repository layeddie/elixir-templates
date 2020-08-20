defmodule NimbleWeb.Router do
  use NimbleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", NimbleWeb do
    pipe_through :browser

    get "/", PageController, :index
  end
end
