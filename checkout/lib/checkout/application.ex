defmodule Checkout.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Checkout.Session
    ]

    opts = [strategy: :one_for_one, name: Checkout.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
