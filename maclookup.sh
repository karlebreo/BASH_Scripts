#!/bin/bash


inputCount="$#"

# Print Help
echo -e "\n   ###############################################################################################"
echo -e "   ## This script will help you identify MAC address Vendor via OUI                             ##"
echo -e "   ## An OUI or Organizationally Unique Identifier is the first 6 characters of a MAC address   ##"
echo -e "   ###############################################################################################"



# Get MAC address from user input
function getMAC() {
        echo -e "\n"
        read -rp "Enter MAC address: " mac_addr
        size=${#mac_addr}
        if [ "$size" -lt 6 ]
                then
                        echo -e "MAC address should be not less then 6 characters"
                        getMAC
                fi
                        getVendor

        }



# Enter another MAC Address
function getNewMAC() {
        echo -e "MAC Address: $newMAC \n"
                mac_addr=$newMAC
                getVendor

        }




# Get MAC address Vendor Name via IEEE
function getVendor() {
        OUI=$(echo "$mac_addr"| tr -dc '[:alnum:]\n\r'| head -c 6 )
        vendorOUI=$(curl -sS "http://standards-oui.ieee.org/oui.txt" | grep -i "$OUI" --color )
        macCheck
        }





# Check if MAC is Valid or Not
function macCheck() {
if [ -z "$vendorOUI" ]
        then
                echo -e "No MAC Vendor or INVALID MAC Address\n"
                read -rp "Input another MAC or press Any_Key to exit: " newMAC
                        sizeRetry=${#newMAC}
                        if [ "$sizeRetry" -ge 6 ]
                                then
                                        getNewMAC
                                        getVendor
                                        macCheck
                                fi
                                        echo -e "GoodBye!"
                                        exit

        else
                echo -e "$vendorOUI\n"
                read -rp "Input another MAC or press Any_Key to exit: " newMAC
                        sizeRetry=${#newMAC}
                        if [ "$sizeRetry" -ge 6 ]
                                then
                                        getNewMAC
                                        getVendor
                                        macCheck
                                fi
                                        echo -e "GoodBye!"
                                        exit

        fi
                echo -e "GoodBye!"
                exit
}




if [ "$inputCount" -gt 0 ]
	then
	echo -e "\n"
	for arg
	do
		OUI=$(echo "$arg"| tr -dc '[:alnum:]\n\r'| head -c 6 )
		vendorOUI=$(curl -sS "http://standards-oui.ieee.org/oui.txt" | grep -i "$OUI" | cut -d')' -f2 | tr -d '\t')
			if [ -z "$vendorOUI" ]
				then
				echo -e "$arg is not a valid MAC Address or not Identified"
				else
				echo -e "$arg is $vendorOUI"
			fi
	done

	else
       		 getMAC

	fi
		exit

