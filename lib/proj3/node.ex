defmodule Proj3.Node do
    use GenServer

    def init(init_state) do
        [nodeInitializationData | _tail] = init_state
        # Initialize this genserver with name, empty routing table and all
        routingTable = Enum.reduce(0..7, %{}, fn currentLevel, acc1 -> 
            slots = Enum.reduce(0..15, %{}, fn x, acc2 -> 
            currentSlot = Helper.currentSlot(x)
            Map.put(acc2, currentSlot, %{})
            end)
            Map.put(acc1, currentLevel, slots)
        end)
        currentState = nodeInitializationData
        currentState = Map.merge(currentState, %{"routingTable" => routingTable})
        # Enum.map(currentState, fn x ->
        #     IO.inspect x[]
        #     # IO.inspect currentState["hashID"]
        #     # IO.inspect x["routingTable"]
             
        #     # x["routingTable"]=make_routingtable(x["hashID"],currentState["hashID"],x["routingTable"])
        # end)
        IO.inspect currentState
        {:ok, currentState}
    end

    # def make_routingtable(currentNodeID,allNodes,routingTable) do
    #     Enum.each(allNodes, fn x -> 
    #         level=longest_prefix(x,currentNodeID,0,0)
    #         temp =String.at(x,level+1)
    #         routingTable[level][temp]=x
    #     end)
    #     routingTable
    # end

    #Function to calculate the level of routing table based on longest common prefix
    def longest_prefix(currentHashID,hashID,i,count) do
        count=
        cond do
            (String.at(hashID,i)==String.at(currentHashID,i))->
                longest_prefix(currentHashID,hashID,i+1,count+1)
            true ->
                count
        end
        count
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