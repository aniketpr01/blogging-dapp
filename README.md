# blogging-dapp


Foundry commands


export PRIVATE_KEY=0xd6031bb46e6e8d2b8bfd2a9369c12de7c1f70320d79dd9e72e00c1d1f321c48f
export CONTRACT_ADDRESS=0x5276ff444E6729D58b824714e95C68961B50eF5F
export RPC_URL=https://polygon-mumbai.g.alchemy.com/v2/VRUMs3WJcJAMuWi9nCZ8rIpkgR9BYhy_
export SUBGRAPH_PLUG=blogging-dapp
export SUBGRAPH_DEPLOY_KEY=7c19eb141cddee7b4fc588adcbc1c63c

forge init --force
forge build
forge test
forge inspect --out build src/Blog.sol:Blog abi
forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY src/Blog.sol:Blog

graph init --contract-name Blog --index-events --studio --from-contract $CONTRACT_ADDRESS --abi /Users/aniket.p/Downloads/blogging-dapp/build/Blog.sol/Blog.json --network mumbai --start-block 0 blogging-dapp /Users/aniket.p/Downloads/blogging-dapp/graph-dir/blog-subgraph
cd graph-dir/blog-subgraph
apply changes to schema.graphql
graph codegen && graph build
graph auth 7c19eb141cddee7b4fc588adcbc1c63c
graph deploy blogging-dapp

// send data to contract address from command line
cast send $CONTRACT_ADDRESS "post(string,string,string,string,string,string[])" "imageUrl1" "imageName1" "assetID1" "playbackId1" "blogcontent1" "['tag1']" --value 0.0001ether --rpc-url $RPC_URL --private-key $PRIVATE_KEY

// call methods from smartcontract
cast call $CONTRACT_ADDRESS "getLatestPosts()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY







