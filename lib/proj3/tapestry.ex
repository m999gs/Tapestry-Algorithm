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
        hashNamesofAllNodes = hashNamesofAllNodes ++ [name]

        {_, mapPID} = Map.fetch(state, :hashedMapPID)
        mapPID = Map.put(mapPID, name, pid)
        
        state = Map.put(state, :hashNamesOfAllNodes, hashNamesofAllNodes)
        state = Map.put(state, :hashedMapPID, mapPID)
        IO.inspect {:noreply, state}
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
end