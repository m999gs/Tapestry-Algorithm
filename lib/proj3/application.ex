defmodule Proj3.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    numNodes = String.to_integer(Enum.at(System.argv(),0), 10)
    listNodes = Enum.map(Enum.to_list(1..numNodes), fn node -> "node#{node}" end) 
    hashNames = Enum.map(listNodes, fn node -> Helper.hashFunction(node) end)
    IO.inspect hashNames

    # Enum.into()
    children = Enum.map(hashNames, fn currentNode-> worker(Proj3.Server, %{name: currentNode, routingTable: %{}}) end)
    # children = [
    #   {Proj3.Server, %{name: 'Node1'}}
    # ]
    
    opts = [strategy: :one_for_one, name: Proj3.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
