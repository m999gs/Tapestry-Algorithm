defmodule Proj3.Node do
    use GenServer

    def init(init_state) do
        pid = self();
        # GenServer.cast(pid, :start)
        [nodeInitializationData | _tail] = init_state
        # Initialize this genserver with name, empty routing table and all
        routingTable = Enum.reduce(0..3, %{}, fn currentLevel, acc1 -> 
            slots = Enum.reduce(0..2, %{}, fn x, acc2 -> 
                currentSlot = Helper.currentSlot(x)
                Map.put(acc2, currentSlot, " ")
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

    def terminate(reason, _current_state) do
        IO.inspect reason
        IO.puts "Exiting GenServer ###########------------#######"
    end

    #Client Side Methods
    @server Proj3.Node
    def start_link(init_arg) do
        GenServer.start_link(@server, init_arg, debug: [:trace])
    end

    def stop(reason) do
        GenServer.stop(@server, {:terminate, reason})
    end
end