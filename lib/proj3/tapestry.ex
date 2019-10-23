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

    def handle_call({:get}, _from, current_state) do
        {:reply, current_state, current_state}
    end

    def terminate(_reason, state) do
        IO.inspect state
    end

    def get() do
        GenServer.call(@me, {:get})
    end

    def buildNetwork(hash_pid_map)do
        # Enum.reduce(pid_list, fn(x)->Node.ComputeRouteTable(x,hash_pid_map))
        IO.puts "in tapestry's buildnetwork"
        Proj3.Node.fillRoutingTable(hash_pid_map)
    end
end