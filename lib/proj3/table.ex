defmodule Proj3.Table do

    def function(routingTable,hashID,hashnames) do
        t = Enum.reduce(hashnames,routingTable, fn {_,x},acc -> 
             
            a = to_string(hashID)
            b = to_string x
            level= longest_prefix(a,b,0,0)

            temp= String.at(x,level)
            
            {_, rlevel} = Map.fetch(routingTable, level)
            x = Map.put(rlevel, temp, x)
            Map.put(acc,level,x)
        end)
        t
    end

    def longest_prefix(currentHashID,hashID,i,count) do
        count=cond do
            String.equivalent?(currentHashID,hashID) ->
                (String.length(currentHashID))-1
            (String.at(hashID,i)==String.at(currentHashID,i))->
                longest_prefix(currentHashID,hashID,i+1,count+1)
            true ->
                count
        end
        count
    end
end