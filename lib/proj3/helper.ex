defmodule Helper do

    def hashFunction(input) do
        :crypto.hash(:sha, input) |> Base.encode16
    end
    
    def currentSlot(index) do
        slots = "0123456789ABCDEF"
        String.at(slots, index)
    end
end