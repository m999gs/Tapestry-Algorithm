defmodule Proj3.Tapestry do
    use GenServer
    @me __MODULE__

    def start_link(arg) do
        GenServer.start_link(@me, arg, name: @me)
    end

    def init(init_state) do
        {:ok, init_state}
    end

    def handle_cast({:add_node_name_to_global_list, name, pid}, state) do
        {_, hashNamesofAllNodes} = Map.fetch(state, :hashNamesOfAllNodes)
        hashNamesofAllNodes = Map.put(hashNamesofAllNodes, map_size(hashNamesofAllNodes) + 1, name)

        {_, mapPID} = Map.fetch(state, :hashedMapPID)
        mapPID = Map.put(mapPID, name, pid)
        
        state = Map.put(state, :hashNamesOfAllNodes, hashNamesofAllNodes)
        state = Map.put(state, :hashedMapPID, mapPID)
        {:noreply, state}
    end

    def handle_cast({:update_child_count}, current_state) do
        numNodes = Map.get(current_state, :numNodes)
        new_state = Map.put(current_state, :numNodes, numNodes + 1)
        {:noreply, new_state}
    end

    def handle_call({:get}, _from, current_state) do
        {:reply, current_state, current_state}
    end

    def terminate(_reason, state) do
        IO.inspect state
        IO.puts "***** Exiting Tapestry GenServer *****"
    end

    def get() do
        GenServer.call(@me, {:get})
    end
 
    def makeRoutingTable(tapestry_server_state) do
        Proj3.Node.fillRoutingTable(tapestry_server_state)
    end

    def selectSourceAndDestinationNodes(tapestry_server_state) do
        numRequests = Map.get(tapestry_server_state, :numRequests)
        sourceDestination = Map.new
        hashNamesMap = Map.get(tapestry_server_state, :hashNamesOfAllNodes)
        sourceDestination = Enum.map(hashNamesMap, fn {_key, hashName} ->
            destinationMap = Enum.reduce(1..numRequests, %{}, fn x, acc2 -> 
                    {_, dest} = Enum.random(hashNamesMap)
                    Map.put(acc2, x, dest)
                end)
            Map.put(sourceDestination, hashName, destinationMap) 
        end)
        sourceDestination
    end

    def updateChildCount() do
        GenServer.cast(@me, {:update_child_count})
    end
end