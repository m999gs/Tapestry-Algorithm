defmodule Proj3.Node do
    use GenServer

    def init(init_state) do
        pid = self();
        # GenServer.cast(pid, :start)
        [nodeInitializationData | _tail] = init_state
        # Initialize this genserver with name, empty routing table and all
        routingTable = Enum.reduce(0..3, %{}, fn currentLevel, acc1 -> 
            slots = Enum.reduce(0..15, %{}, fn x, acc2 -> 
                currentSlot = Helper.currentSlot(x)
                Map.put(acc2, currentSlot, "")
            end)
            Map.put(acc1, currentLevel, slots)
        end)
        currentState = nodeInitializationData
        currentState = Map.merge(currentState, %{routingTable: routingTable})
        currentState = Map.put_new(currentState, :pid, pid)
        
        #This method adds hashname to global list of hashnames that is stored under Tapestry's state
        GenServer.cast(Proj3.Tapestry, {:add_node_name_to_global_list, currentState.hashID, pid})
        {:ok, currentState}
    end

    def handle_call({:get_state}, _from, current_state) do
        {:reply, current_state, current_state}
    end

    def handle_call({:updateRoutingTable, currentNodeId, allHashNames}, _from, current_state) do
        newRoutingTable = routingTableFunction(Map.get(current_state, :routingTable), currentNodeId, allHashNames)
        current_state = Map.put(current_state, :routingTable, newRoutingTable)
        {:reply, current_state, current_state}
    end

    def terminate(reason, _current_state) do
        IO.inspect reason
        IO.puts "***** Exiting Node GenServer *****"
    end

    #Client Side Methods
    @server Proj3.Node
    def start_link(init_arg) do
        GenServer.start_link(@server, init_arg)
    end

    def stop(reason) do
        GenServer.stop(@server, {:terminate, reason})
    end

    def fillRoutingTable(tapestry_state) do
        {:ok, pid_map} = Map.fetch(tapestry_state, :hashedMapPID)
        {:ok, allHashNames} = Map.fetch(tapestry_state, :hashNamesOfAllNodes)
        
        #Update every node's routing table
        # Enum.map(pid_map, fn {hashName, pid} -> updateRoutingTable(pid, hashName, allHashNames) end)
        
        Enum.map(pid_map, fn {hashName, pid} -> 
            Task.async(fn -> updateRoutingTable(pid, hashName, allHashNames) end) 
        end)
        |> Enum.map(fn (task) -> Task.await(task, :infinity) end)

        #Run a function to start sending requests here
    end

    #Gets called by the function above
    def updateRoutingTable(pid, currentNodeId, allHashNames) do
        GenServer.call(pid, {:updateRoutingTable, currentNodeId, allHashNames}, 100000)
    end

    def get_current_state_of_node(pid) do
        GenServer.call(pid, {:get_state})
    end
    # computing the newly joining node after creating the network.
    def newNodeRoutingTable(routingTable, hashID, hashNames) do
        max = 0 #variable for the longest matching prefix
        string = "" # variable for the nearest hashID

        #Finding the nearest node of the new node in the existing network and the longest matching prefix
        {maxValue,nearestHashId} = Enum.reduce(hashNames,{max,string}, fn {_,x} ,acc -> 
            level = longest_prefix(hashID,x,0,0)
            acc=
            cond do
                max < level ->
                    max = level
                    {max,x}
                true->
                    acc
            end
            acc
        end)

        #fetching the routing table of the nearest node
        oldRoutingtable = Proj3.Route.getRoutingTable(nearestHashId)

        #copying the 0 to maxValue levels of the nearest node in the newly joining node routing table
        routingTable = Enum.reduce(0..maxValue,routingTable, fn x, acc -> 
                Map.put(acc,x,Map.get(oldRoutingtable,x))
        end)

        #Computing the rest of the lower nodes of new node
        t = Enum.reduce(hashNames, routingTable, fn {_,x},acc ->
            level= longest_prefix(hashID,x,0,0)
            acc = 
            cond do
                level > maxValue ->
                    acc = Enum.reduce((maxValue+1)..level, acc, fn y, acc2->
                    temp= String.at(x,y)
                    {_, rlevel} = Map.fetch(acc, y)
                    x = Map.put(rlevel, temp, x)
                    Map.put(acc2,y,x)
                    end)
                    acc
                true ->
                    acc
            end
            acc
         end)
        #returning the final routing table 
        t
    end

    #computing the routing tables at the time of initialization.
    def routingTableFunction(routingTable, hashID, hashNames) do
           t = Enum.reduce(hashNames, routingTable, fn {_,x}, acc ->
           level = longest_prefix(hashID, x, 0, 0)
           Enum.reduce(0..level, acc, fn y, acc2->
                temp = String.at(x, y)
                {_, rlevel} = Map.fetch(acc, y)
                x = Map.put(rlevel, temp, x)
                Map.put(acc2, y, x)
            end)
        end)
        t
    end

    def longest_prefix(currentHashID, hashID, i, count) do
        count = cond do
            String.equivalent?(currentHashID, hashID) ->
                (String.length(currentHashID)) - 1
            (String.at(hashID,i)==String.at(currentHashID, i))->
                longest_prefix(currentHashID, hashID, i + 1, count + 1)
            true ->
                count
        end
        count
    end
end