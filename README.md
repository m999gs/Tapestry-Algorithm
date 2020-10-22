# Project 3 -> Tapestry Network

## Team Members:
 Maharshi Rawal <br />
 Mohit Garg


## **Installation and Run** 

**Make sure to install Elixir on your PC.** <br />
1. Unzip the zip archive and navigate to the extracted folder. <br/>
2. Open the Terminal/Command Prompt. <br />
3. Format of Arguments :   **$** mix run project3.exs argument1  argument2 <br />
     **Where:**<br />
     Argument 1 is the number of actors (or nodes) in the network **(Any number greater than 1)**<br />
     Argument 2 is the number of requests each node makes <br />

## **What is Working**

1. We have implemented the Tapestry Network with Nodes having names from sha1 hashing which are then truncated to 8 bits.
2. All the nodes have their respective routing tables which consists of other nodes with their prefix matched.
3. The nodes decide the routing path depending on the matching prefixes in their routing tables.
4. There is a dynamic node entry in the tapestry network after its initialization. It computes its routing table by matching prefixes of the existing nodes in the network to find its nearest neighbor and notifies the neighboring nodes to recompute their respective routing tables.

## **Largest Network Tested**

<<<<<<< HEAD
The largest network we tested was 9000 nodes with maximum 5 hops of nodes traversed in a 8-level routing table

| Nodes | Requests | Max Hops |
| --- | --- | --- |
| 10 | 5 | 1 |
| 100 | 10 | 2 |
| 100 | 20 | 2 |
| 500 | 20 | 3 |
| 1000 | 10 | 4 |
| 1000 | 20 | 4 |
| 2000 | 10 | 4 |
| 4000 | 10 | 4 |
| 7000 | 5 | 5 |
| 8000 | 5 | 5 |
| 9000 | 5 | 5 |
=======
The largest network we tested was 5000 nodes. It does work after that but it runs very slowly.


7000 5 -> Hops 5
8000 5 -> Hops 5
9000 5 -> Hops 5
>>>>>>> cbc75aa7c90aded926bce3263c4fd502885fd416
