defmodule Proj3 do

    def main(args \\ []) do
        startProject(args)
    end

    def startProject(args) do
        [numNodes, numRequests] = args
        Application.start(:normal, {numNodes, numRequests})
    end
end