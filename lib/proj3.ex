defmodule Proj3 do

    def main(args \\ []) do
        startProject(args)
    end

    def startProject(args) do
        IO.puts "Project started"
        [numNodes, numRequests] = args
        IO.inspect numNodes
        IO.inspect numRequests

        # TODO: Put logic to define supervisors and genservers 
    end

end
