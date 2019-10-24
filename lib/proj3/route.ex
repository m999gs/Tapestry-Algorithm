defmodule Proj3.Route do
    #routing algorithm
    def route(sourceID, destinationID, routingTable, numHops) do
        level= Proj3.Node.longest_prefix(sourceID, destinationID, 0, 0)
        col=String.at(destinationID,level)
        IO.inspect newSourceID=to_string(routingTable[level][col])
        #fetching the routing table
        pid_map = Map.get(Proj3.Tapestry.get(),:hashedMapPID)
        pid=Map.get(pid_map, newSourceID)
        node_state = Proj3.Node.get_current_state_of_node(pid)
        newRoutingTable = Map.get(node_state,:routingTable)
        #routing table fetched
        t=
        cond do
            String.equivalent?(newSourceID,destinationID) ->
                numHops
            true ->
                route(newSourceID,destinationID,newRoutingTable,numHops+ 1)
        end
        t
    end
end