#!/bin/bash
#Last updated : 01/Dec/2020
#Enablement 
## Naemspaces  You tube video : https://youtu.be/j_UUnlVC2Ss
## IP-Tables Tutorial https://www.karlrupp.net/en/computer/nat_tutorial 

#What & why about the namespaces ?  
#Namesapces are logically like rooms in a house(host), provides isolation between the other rooms
#When a user performs "ps aux" on a namespace, user can only see theprocesses running with in the namespace. User doesn't have visibility to the process running on the host. 


############################################################################################################
#  Network Namespaces  #
# General, Hosts has its own networking which connects to local-area-network, ARP table and Routing tables
## When we create any resources in the  Network namespace, its isolated from the host, i.e resources in a
## namespace doesnt have visibility to the host lan-interface, ARP and routing tables.
## In a namespace, Containers has its own
###     - veth interface
###     - ARP table
###     - Routing table
############################################################################################################# 


#1 Creating new namespace  on a linux host. Example lets create two  namespaces named red and blue
ip netns add red 
ip netns add blue
#2 List of namespaces ip netns
ip netns 

#3 List interfaces on the host
ip link

#4 List interfaces on the namespace red (Prefix ip netns exec <namespacename> followed by ip link (or) use the -n option for the ip command with namesapce name )
ip netns exec red ip link 
#or
ip -n red link


##### Arp commands
#5 ARP command on host
arp 

#6 ARP command on namespace red
ip netns exec red arp

##### Routingtable commands
#5 Routing table command on host
route

#6 Routingtable  command on namespace red
ip netns exec red route

#7 Connecting two namespaces using veth interface (also called as pipe)

##Creating a pipe between red and blue
ip link add veth-red type veth peer name veth-blue
##Link veth interfaces to appropriate namespace
ip link set veth-red netns red
ip link set veth-blue netns blue

#8 Assigning ip addresses to each veth interface
ip -n red addr add 192.168.15.1 dev veth-red
ip -n blue addr add 192.168.15.2 dev veth-blue 

#9 turn up the vether interface links
ip -n red link set veth-red up
ip -n blue link set veth-blue

#10 Lets ping the blue namespace veth from red namespace
ip net exec red ping 192.168.15.2 #15.2 is the ip for the Blue namespace

##### -----------------------------------------------------------------------------
##### How to communicate all the interfaces across the namespace and the host
##### -----------------------------------------------------------------------------
# As a first step we need a Bridge to connect all the interfaces
# We have many options for the bridges such as LinuxBridge, OVS and so on
# Lets go through the linux Bridge

#11 Create Linux bridge name vbridge0 
ip link add vbridge0 type bridge
#12 Validate the vbridge0 visibility on the host, by issuing the following command on the hsot
ip link # You will notice the bridge as a interface along with the other interfaces on the host
ip link set dev vbridge0 up 

# Lets connect the namespaces to the bridge. 
## Delte existing connected interfaces on the namespace red and blue
## Create an virtual pipe/interace  and Attach the interfaces one end to the blue namespace and other end to the Bridge 
ip link add veth-red type veth peer name veth-red-br ## Create the new interfacs from namespace  
ip link set veth-red netns blue #Attach the interfaces one end to the blue namespace 
ip link set veth-red-br master vbridge0 #Attach the interfaces other end to the Bridge
ip -n red addr add 192.168.15.1 dev veth-red #Assgin IP address to the interfaces red
ip -n red link set veth-red up # Turn up the interface red

## Create an virtual pipe/interace  and Attach the interfaces one end to the blue namespace and other end to the Bridge 
ip link add veth-blue type veth peer name veth-blue-br ## Create the new interfacs from namespace  
ip link set veth-blue netns blue #Attach the interfaces one end to the blue namespace 
ip link set veth-blue-br master vbridge0 #Attach the interfaces other end to the Bridge
ip -n red addr add 192.168.15.2 dev veth-blue #Assgin IP address to the interfaces blue
ip -n red link set veth-blue up # Turn up the interface blue

##### -----------------------------------------------------------------------------
##### Connecting bridge to the Host by assigning an appropriate IP for the bridge
##### -----------------------------------------------------------------------------
ip addr add 192.168.15.5/24 dev vbridge0 #Assigning IP address to Bridge

##### -----------------------------------------------------------------------------
##### Reaching to the external world outside the Host
##### -----------------------------------------------------------------------------
## We need to perform two steps 
### Step-1 Add a route in the namespace to route the traffic for othersubnets to Bridge (Using host as a gateway)
### Step-2 Adding a NAT entry in the iptables to the Host  (or) NAT enable on our host actiing as a gateway for the private bridges on the host
ip netns exec blue ip route add 192.168.1.0/24 via 192.168.15.5 
#(or add a default route so all the traffic not related to the interface aka external traffic, will reach to host through bridge)
ip netns exec blue ip route add default via 192.168.15.5 ## Any external host talk to our host via Bridge
iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -j MASQUERADE #Masquerade meaning replace the from address on the  all packet coming from the source network 192.168.15.0/24, with the HostIP address. 

##### -----------------------------------------------------------------------------
##### Reaching from the external world to the namespace
##### -----------------------------------------------------------------------------
### To make there are two options
## Option-1DNAT entry via the HostIP
## Option2 - Portforwarding rules

iptables -t nat -A PREROUTING --dport 80 --to-destination 192.168.15.2:80 -J DNAT
 





### Validation commands
#1 Look at the arptable on the red namespace after the ping
ip netns exec red arp
#2 Look at the arptable on the blue namespace after the ping
ip netns exec blue arp
