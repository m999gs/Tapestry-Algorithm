defmodule Proj3.Node do
    use GenServer

    def init(init_state) do
        [nodeInitializationData | _tail] = init_state
        # Initialize this genserver with name, empty routing table and all
        
        currentState = nodeInitializationData
        {:ok, currentState}
    end

    #Function to calculate the level of routing table based on longest common prefix
    


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