defmodule Proj3.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    numNodes = String.to_integer(Enum.at(System.argv(),0), 10)
        
    children = Enum.reduce(1..numNodes, [], fn x, acc -> 
      currentNode = "node#{x}"
      hashName = Helper.hashFunction(currentNode)
      [Supervisor.child_spec({Proj3.Node, [%{hashID: hashName, name: currentNode}, x]}, id: {Proj3.Node, x}, restart: :temporary) | acc]
      end)
    
    opts = [strategy: :one_for_one, name: Proj3.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
