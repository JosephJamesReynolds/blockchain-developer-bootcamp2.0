markdow# Joseph's Token Exchange

Welcome to Joseph's Token Exchange! This decentralized application (Dapp) allows you to make transactions on both the Sepolia Test Network and a local Hardhat network.

## Features

- Connect with MetaMask wallet
- Trade tokens on Sepolia Test Network
- Local development and testing with Hardhat

## Prerequisites

- Node.js and npm installed
- MetaMask browser extension
- Basic understanding of Ethereum and smart contracts

## Detailed Setup

1. Clone this repository to your local machine.

2. Install dependencies:
   npm install
3. Set up your environment variables:

- Create a file named `.env` in the root directory of the project.
- Add the following lines to the file:
  ```
  PRIVATE_KEY_1=your_first_private_key
  PRIVATE_KEY_2=your_second_private_key
  ALCHEMY_API_KEY=your_alchemy_api_key
  ```

To get your private keys:

- Open MetaMask
- Click on the three dots next to your account
- Go to "Account details"
- Click "Export Private Key"
- Enter your password and the private key
- Paste this key as the value for PRIVATE_KEY_1 in your .env file
- Repeat for a second account for PRIVATE_KEY_2

To get your Alchemy API key:

- Sign up for an account at https://www.alchemy.com/
- Create a new app for the Sepolia network
- the API key and paste it as the value for ALCHEMY_API_KEY in your .env file

## Using the Hardhat Local Network

1. Start the Hardhat node:
   npx hardhat node
2. Open a new terminal window. Deploy the contracts:
   npx hardhat run scripts/deploy.js --network localhost
3. (Optional) Seed the exchange with initial orders:
   npx hardhat run scripts/seed-exchange.js --network localhost
4. Start the frontend:
   npm start
5. In MetaMask:

- Add a new network with:
  - Network Name: Hardhat
  - New RPC URL: http://127.0.0.1:8545/
  - Chain ID: 31337
- Import accounts using private keys provided by Hardhat (printed in the console when you ran `npx hardhat node`)

## Using the Sepolia Test Network

1. Get Sepolia ETH:

- Go to https://sepoliafaucet.com/
- Connect your MetaMask wallet
- Request test ETH (this may take a few minutes)

2. Deploy the contracts to Sepolia:
   npx hardhat run scripts/deploy.js --network sepolia
3. (Optional) Seed the exchange:
   npx hardhat run scripts/seed-exchange.js --network sepolia
4. Start the frontend:
   npm start
5. In MetaMask:

- Switch to the Sepolia network
- Ensure you have Sepolia ETH in your account

## Running the Dapp

1. After starting the frontend with `npm start`, open your browser to `http://localhost:3000`
2. Connect your MetaMask wallet to the Dapp
3. You should now be able to interact with the exchange!

## Additional Hardhat Tasks

For developers, this project includes several Hardhat tasks:

```shell
npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node
npx hardhat run scripts/1_deploy.js
Troubleshooting
If you encounter issues:

Ensure all dependencies are installed
Check that your .env file is set up correctly
Make sure you're connected to the correct network in MetaMask
Clear your browser cache and MetaMask activity if you experience unexpected behavior

Contributing
Contributions are welcome! Please feel free to submit a Pull Request.
```
