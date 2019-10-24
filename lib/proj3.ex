defmodule Proj3 do

    def main(args \\ []) do
        startProject(args)
    end

    def startProject(args) do
        # IO.puts "Project started"
        [numNodes, numRequests] = args
        # Proj3.Supervisor.start_link(numNodes)
        Application.start(:normal, {numNodes, numRequests})
        # TODO: Put logic to define supervisors and genservers 
    end

end
