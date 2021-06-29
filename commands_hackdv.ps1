Set-ADForest -Identity "ad.hackdv.com" -UPNSuffixes @{add="hackdv.com"}
Install-TransportAgent -Name "ABP Routing Agent" -TransportAgentFactory “Microsoft.Exchange.Transport.Agent.AddressBookPolicyRoutingAgent.AddressBookPolicyRoutingAgentFactory” -AssemblyPath $env:ExchangeInstallPath\TransportRoles\agents\AddressBookPolicyRoutingAgent\Microsoft.Exchange.Transport.Agent.AddressBookPolicyRoutingAgent.dll
Enable-TransportAgent "ABP Routing Agent"
Restart-Service MSExchangeTransport
Get-TransportAgent
Set-TransportConfig -AddressBookPolicyRoutingEnabled $true
New-AcceptedDomain -Name "hackdv.com" -DomainName hackdv.com -DomainType:Authoritative
New-GlobalAddressList -Name "Global Address List hackdv.com" -ConditionalCustomAttribute2 "hackdv.com" -IncludedRecipients MailboxUsers,MailGroups,MailContacts -RecipientContainer "ad.hackdv.com/Kunden/hackdv.com"
New-AddressList -Name "All Rooms hackdv.com" -RecipientFilter "(CustomAttribute2 -eq 'hackdv.com') -and (RecipientDisplayType -eq 'ConferenceRoomMailbox')" -RecipientContainer "ad.hackdv.com/Kunden/hackdv.com"
New-AddressList -Name "All Users hackdv.com" -RecipientFilter "(CustomAttribute2 -eq 'hackdv.com') -and (ObjectClass -eq 'User')" -RecipientContainer "ad.hackdv.com/Kunden/hackdv.com"
New-AddressList -Name "All Contacts hackdv.com" -RecipientFilter "(CustomAttribute2 -eq 'hackdv.com') -and (ObjectClass -eq 'Contact')" -RecipientContainer "ad.hackdv.com/Kunden/hackdv.com"
New-AddressList -Name "All Groups hackdv.com" -RecipientFilter "(CustomAttribute1 -eq 'hackdv.com') -and (ObjectClass -eq 'Group')" -RecipientContainer "ad.hackdv.com/Kunden/hackdv.com"
New-OfflineAddressBook -Name "hackdv.com" -AddressLists "Global Address List hackdv.com"
New-AddressBookPolicy -Name "hackdv.com Address Book Policy" -AddressLists "\All Users hackdv.com","\All Groups hackdv.com","\All Contacts hackdv.com" -RoomList "\All Rooms hackdv.com" -OfflineAddressBook "\hackdv.com" -GlobalAddressList "\Global Address List hackdv.com"
Set-OrganizationConfig -mapihttpenabled $false