defmodule Proj3.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    numNodes = String.to_integer(Enum.at(System.argv(),0), 10)
    :ets.new(:hash_names, [:set, :protected, :named_table])
        
    children = Enum.reduce(1..numNodes, [], fn x, acc -> 
      currentNode = "node#{x}"
      hashName = Helper.hashFunction(currentNode)
      # Trim hashname from 40 bits to 8 bits (remove this once final)
      hashName = String.slice(hashName, 0..3)
      {hashNameInteger, _} = Integer.parse(hashName, 16)
      # IO.puts("Hashname: #{hashName}, HashNameInteger: #{hashNameInteger}")
      [Supervisor.child_spec({Proj3.Node, [%{hashID: hashName, name: currentNode, hashNameInteger: hashNameInteger}, x]}, id: {Proj3.Node, x}, restart: :temporary) | acc]
      end)
    
    opts = [strategy: :one_for_one, name: Proj3.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
