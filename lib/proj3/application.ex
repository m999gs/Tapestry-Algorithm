defmodule Proj3.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    numNodes = String.to_integer(Enum.at(System.argv(),0), 10)
    numRequests = String.to_integer(Enum.at(System.argv(),1), 10)
    tapestry = Supervisor.child_spec({Proj3.Tapestry, %{numNodes: numNodes - 1, numRequests: numRequests, hashNamesOfAllNodes: %{}, hashedMapPID: %{}}}, restart: :transient)
    registry = {Registry, keys: :unique, name: Proj3.Registry, partitions: System.schedulers_online()}
    children = Enum.reduce(1..(numNodes - 1), [], fn x, acc -> 
      currentNode = "node#{x}"
      hashName = Helper.hashFunction(currentNode)
      # Trim hashname from 40 bits to 8 bits (remove this once final)
      hashName = String.slice(hashName, 0..3)
      {hashInteger, _} = Integer.parse(hashName, 16)
      [Supervisor.child_spec({Proj3.Node, [%{hashID: hashName, name: currentNode, hashInteger: hashInteger}, x]}, id: {Proj3.Node, x}, restart: :temporary) | acc]
      end)
    
    children_all = [tapestry | [registry | children]]
    opts = [strategy: :one_for_one, name: Proj3.Supervisor]
    {:ok, application_pid} = Supervisor.start_link(children_all, opts)

    Proj3.Tapestry.makeRoutingTable(Proj3.Tapestry.get())

    newRoutingTable = Proj3.Route.getRoutingTable("B0A6")

    IO.inspect Proj3.Route.route("B0A6","B0A6", newRoutingTable, 0)

    #ADD New Node to Network (Network Join)
    newNodehashName = Helper.hashFunction("node#{numNodes}")
    newNodehashName = String.slice(newNodehashName, 0..3)
    {newNodeHashInteger, _} = Integer.parse(newNodehashName, 16) 
    newChildSpec = Supervisor.child_spec({Proj3.Node, [%{hashID: newNodehashName, name: "node#{numNodes}", hashInteger: newNodeHashInteger}, numNodes]}, id: {Proj3.Node, numNodes}, restart: :temporary)
    Supervisor.start_child(application_pid, newChildSpec)
    Proj3.Tapestry.updateChildCount()

    sourceDestinationMap = Proj3.Tapestry.selectSourceAndDestinationNodes(Proj3.Tapestry.get())
    
    

    Enum.each(sourceDestinationMap, fn currentNode -> 
      sourceNode = Map.keys(currentNode)

      destinationNodes = Map.values(currentNode)

      #make a routing request here 
    end)

    {:ok, application_pid}
  end
end
