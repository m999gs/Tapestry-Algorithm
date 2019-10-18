arguments = Enum.to_list(System.argv())
numNodes = String.to_integer(Enum.at(arguments, 0), 10)
numRequests = String.to_integer(Enum.at(arguments, 1), 10)
Proj3.main([numNodes, numRequests])