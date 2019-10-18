defmodule Proj3.Server do
    use GenServer

    def init(init_arg) do
        IO.inspect {:ok, init_arg}
    end

    def terminate(reason, current_state) do
        IO.inspect reason
        IO.puts "Exiting GenServer ###########------------#######"
    end

    #Client Side Methods
    @server Proj3.Server
    def start_link(init_arg) do
        GenServer.start_link(@server, init_arg, [name: TapestryServer, debug: [:trace]])
    end

    def stop(reason) do
        GenServer.stop(@server, {:terminate, reason})
    end
end