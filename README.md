# G.A.S.T. Go-Kart Rental Script for FiveM 
Made by G.A.S.T. Development - andrejkm

This Go-Kart Rental script is designed for FiveM servers using both ESX and QBCore frameworks. It allows players to rent vehicles from an NPC with multiple interaction methods and payment options, supporting multiple frameworks for better compatibility.

## Features
✅ **Framework Support: Compatible with both ESX and QBCore.**

✅ **Interaction Types: Supports ox_target, qb-target, and textui.**

✅ **Payment Handling: Ensures correct deduction of player money with server-side validation.**

✅ **Configurable Notifications: Works with ox_lib, esx, and qbcore notification systems.**

✅ **Society Integration: Earnings from vehicle rentals can be directed to society accounts for both ESX and QBCore.**

Spawn:
https://drive.google.com/file/d/1YNqT1mig5DX-Q1ZryMulczjZfsDijYgU/view?usp=sharing

Go-Kart remove:
https://drive.google.com/file/d/1tCUsUAFgp6izlk6HnDdcg4yz6Qs4krPb/view?usp=sharing

## Requirements
ESX Legacy or QBCore Framework
ox_lib (optional)
ox_target / qb-target (for advanced interaction)
qb-management (for society account handling in QBCore)

## Installation

## Installation
1. Download and extract the files into your FiveM server's resources directory.
2. Add the resource to your `server.cfg`:
   ```plaintext
   ensure gast_karts
   ```
3. Ensure you have the `es_extended` and `ox_inventory` resources properly installed and running.
4. Configure Config.lua:
5. Set your framework (esx or qbcore)
6. Choose interaction method (ox_target, qb-target, textui)
7. Set rental prices and vehicles
8. Configuration Example (Config.lua)

Config.Framework = "qbcore"
Config.InteractionType = "qb-target"
Config.NotificationType = "ox_lib"
Config.SocietyAccount = "society_karting"
Config.RentalVehicles = {
    {model = "kart", displayName = "Go-Kart"}
}
Config.RentalTimes = {
    {time = 10, price = 500},
    {time = 20, price = 800}
}

## Usage
1. NPC Interaction: Walk up to the NPC and interact using your configured method (e.g., ox_target or textui).

2. Vehicle Rental: Choose a vehicle and rental duration from the menu.

3. Payment Handling: If the player has enough money, the vehicle will be spawned, and money will be deducted.

## Known Issues
Ensure all required resources (ox_target, qb-target, qb-management) are properly installed.
Society accounts must be configured correctly in the Config.lua.

## Support
For issues or suggestions, please open create an issue on the GitHub repository.
