defmodule Proj3.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    numNodes = String.to_integer(Enum.at(System.argv(),0), 10)
    hashName = Enum.reduce(1..numNodes,%{} , fn x,acc -> 
      Map.put(acc,x,String.slice(Helper.hashFunction("node#{x}"), 0..7)) 
    end)
    children = Enum.reduce(1..numNodes, [], fn x, acc -> 
      currentNode = "node#{x}"
      routingTable = routingtable(hashName[x],hashName)
      [Supervisor.child_spec({Proj3.Node, [%{ hashID: hashName[x], name: currentNode,hashnames: hashName,routingTable: routingTable}, x]}, id: {Proj3.Node, x}, restart: :temporary) | acc]
      end)
    opts = [strategy: :one_for_one, name: Proj3.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def routingtable(hashID,hashnames) do
    routingTable = Enum.reduce(0..7, %{}, fn currentLevel, acc1 -> 
      slots = Enum.reduce(0..15, %{}, fn x, acc2 -> 
      currentSlot = Helper.currentSlot(x)
      Map.put(acc2, currentSlot, %{})
      end)
      Map.put(acc1, currentLevel, slots)
    end)
    Proj3.Table.function(routingTable,hashID,hashnames)
  end
    
end
