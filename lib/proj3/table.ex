defmodule Proj3.Table do

    def function(routingTable,hashID,hashnames) do
        t = Enum.reduce(hashnames,routingTable, fn {_,x},acc -> 
            level= 0#longest_prefix(x,hashID,0,0)
            temp=
            cond do
                level == String.length(x) ->
                    String.at(x,level-1)
                true ->
                    String.at(x,level)
            end
            {_, rlevel} = Map.fetch(routingTable, level)
            x = Map.put(rlevel, temp, x)
            Map.put(acc,level,x)
        end)
        IO.inspect t
        t
    end

    def longest_prefix(currentHashID,hashID,i,count) do
        count=cond do
            (String.at(hashID,i)==String.at(currentHashID,i))->
                longest_prefix(currentHashID,hashID,i+1,count+1)
            true ->
                count
        end
        count
    end
end