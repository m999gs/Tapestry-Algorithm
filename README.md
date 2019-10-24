# Project 3 -> 

## Team Members:
 Maharshi Rawal (UFID: 9990-8457) <br />
 Mohit Garg (UFID: 9013-4089)


## **Installation and Run** 

**Make sure to install Elixir on your PC.** <br />
1. Unzip the zip archive and navigate to the extracted folder. <br/>
2. Open the Terminal/Command Prompt. <br />
3. Format of Arguments 

   (For Mac/Linux Users):    **$** mix run project3.exs argument1  argument2 <br />
   (For Windows Users): **$** mix run project3.exs argument1  argument2  <br />
   
   **Where:**<br />
     Argument 1 is the number of actors (or nodes) in the network **(Any number greater than 1)**<br />
     Argument 2 is the number of requests each node makes <br />

## **What is Working**

1. We have implemented the Tapestry Network with Nodes having names from sha1 hashing which are then truncated to 8 bits.
2. All the nodes have their respective routing tables which consists of other nodes with their prefix matched.
3. The nodes decide the routing path depending on the matching prefixes in their routing tables.


## **Largest Network Tested**

The largest network we tested was 5000 nodes. It does work after that but it runs very slowly.