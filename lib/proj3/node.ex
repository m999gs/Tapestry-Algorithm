defmodule Proj3.Node do
    use GenServer

    def init(init_state) do
        [nodeInitializationData | _tail] = init_state
        # Initialize this genserver with name, empty routing table and all
        routingTable = Enum.reduce(0..15, %{}, fn x, acc -> 
            currentIndex = Helper.currentSlot(x)
            Map.put(acc, currentIndex, %{})
        end)
        currentState = nodeInitializationData
        # Map.put_new(currentState, routingTable)
        IO.inspect routingTable
        IO.inspect {:ok, currentState}
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