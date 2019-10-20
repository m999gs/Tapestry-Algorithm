numNodes = String.to_integer(Enum.at(System.argv(),0), 10)
numRequests = String.to_integer(Enum.at(System.argv(),1), 10)
Proj3.main([numNodes, numRequests])