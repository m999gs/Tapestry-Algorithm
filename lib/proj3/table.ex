defmodule Proj3.Table do

    def function(routingTable,hashID,hashnames) do

        t = Enum.reduce(hashnames,routingTable, fn {_,x},acc ->

            level= longest_prefix(hashID,x,0,0)
           q= Enum.reduce(0..level,acc,fn y, acc2->
                temp= String.at(x,y)
                {_, rlevel} = Map.fetch(acc, y)
                x = Map.put(rlevel, temp, x)
                acc2 = Map.put(acc2,y,x)
            end)
            acc = q
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