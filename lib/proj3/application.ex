defmodule Proj3.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    numNodes = String.to_integer(Enum.at(System.argv(),0), 10)
    numRequests = String.to_integer(Enum.at(System.argv(),1), 10)
    IO.puts "Computing the max number of hops..."
    tapestry = Supervisor.child_spec({Proj3.Tapestry, %{numNodes: numNodes - 1, numRequests: numRequests, maxHops: 0, hashNamesOfAllNodes: %{}, hashedMapPID: %{}}}, restart: :transient)
    children = Enum.reduce(1..(numNodes - 1), [], fn x, acc -> 
      currentNode = "node#{x}"
      hashName = Helper.hashFunction(currentNode)
      # Trim hashname from 40 bits to 8 bits (remove this once final)
      hashName = String.slice(hashName, 0..7)
      {hashInteger, _} = Integer.parse(hashName, 16)
      [Supervisor.child_spec({Proj3.Node, [%{hashID: hashName, name: currentNode, hashInteger: hashInteger}, x]}, id: {Proj3.Node, x}, restart: :temporary) | acc]
      end)
    
    children_all = [tapestry | children]
    opts = [strategy: :one_for_one, name: Proj3.Supervisor]
    {:ok, application_pid} = Supervisor.start_link(children_all, opts)

    #  Make routing table of all nodes
    Proj3.Tapestry.makeRoutingTable(Proj3.Tapestry.get())
    
    # ADD New Node to Network (Network Join)
    newNodehashName = Helper.hashFunction("node#{numNodes}")
    newNodehashName = String.slice(newNodehashName, 0..7)
    {newNodeHashInteger, _} = Integer.parse(newNodehashName, 16) 
    newChildSpec = Supervisor.child_spec({Proj3.Node, [%{hashID: newNodehashName, name: "node#{numNodes}", hashInteger: newNodeHashInteger}, numNodes]}, id: {Proj3.Node, numNodes}, restart: :temporary)
    Supervisor.start_child(application_pid, newChildSpec)
    
    Proj3.Tapestry.updateChildCount()
    newRoutingTable = Proj3.Node.newNodeRoutingTable(Proj3.Route.getRoutingTable(newNodehashName), newNodehashName, Map.get(Proj3.Tapestry.get(), :hashNamesOfAllNodes))
    pid_map = Map.get(Proj3.Tapestry.get(), :hashedMapPID)
    pid = Map.get(pid_map, newNodehashName)
    Proj3.Node.updateNewNodeTable(pid, newRoutingTable)

    sourceDestinationMap = Proj3.Tapestry.selectSourceAndDestinationNodes(Proj3.Tapestry.get())

    Enum.reduce(sourceDestinationMap, [], fn currentNode, _acc -> 
      sourceNode = Map.keys(currentNode)
      sourceNode = List.first(sourceNode)
      destinationNodes = Map.values(currentNode)
      destinationNodes = List.first(destinationNodes)
      Enum.reduce(destinationNodes, [], fn {_key, destinationNode}, _acc ->
        #make a routing request here 
        sourceRoutingTable = Proj3.Route.getRoutingTable(sourceNode)
        hops = Proj3.Route.route(sourceNode, destinationNode, sourceRoutingTable, 0)
        #compute maxHops
        computeMax(hops)
      end)
    end)

    {_, maxHops} = Map.fetch(Proj3.Tapestry.get(), :maxHops)
    IO.puts "The max number of hops in the network are #{maxHops}"
    {:ok, application_pid}
  end

  def computeMax(hopCount) do
    Proj3.Tapestry.computeMaxHop(hopCount)
  end
end
