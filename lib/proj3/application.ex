defmodule Proj3.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Proj3.Server, ['hello']}
    ]
    
    opts = [strategy: :one_for_one, name: Proj3.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
