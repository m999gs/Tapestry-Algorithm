defmodule Helper do

    def hashFunction(input) do
        :crypto.hash(:sha, input) |> Base.encode16
    end    
end