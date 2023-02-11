// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Blog {
    address owner;
    mapping(address => uint256) paidEth;

    constructor() {
        owner = msg.sender;
    }

    function greet() public pure returns (string memory) {
        return "This is a blog!";
    }

    function post(
        string memory postType,
        bytes memory postData,
        string[] memory tags
    ) public payable {
        // string memory imageType = "image";
        require(msg.value > 0, "You must pay some ETH to post content");
        paidEth[msg.sender] += msg.value;
        string memory imageHash;
        string memory videoHash;

        if (
            keccak256(abi.encodePacked(postType)) ==
            keccak256(abi.encodePacked("image"))
        ) {
            imageHash = storeImageOnFilecoin(postData, tags);
        } else if (
            keccak256(abi.encodePacked(postType)) ==
            keccak256(abi.encodePacked("video"))
        ) {
            videoHash = storeVideoOnLivepeer(postData, tags);
        }

        // Notify the author using the push protocol
        // ...
    }

    function storeImageOnFilecoin(bytes memory imageData, string[] memory tags)
        private
        returns (string memory)
    {
        // Call the function that stores the image on Filecoin and returns the IPFS hash
        // ...
    }

    function storeVideoOnLivepeer(bytes memory videoData, string[] memory tags)
        private
        returns (string memory)
    {
        // Call the function that stores the video on livepeer and returns the IPFS hash
        // ...
    }

    function rewardAuthor(address payable author, uint256 reward)
        public
        payable
    {
        require(
            msg.value >= reward,
            "The reward must be equal to or less than the sent ETH"
        );
        require(author != address(0), "The author address must be valid");
        author.transfer(reward);

        // Notify the author using the push protocol
        // ...
    }

    function getPaidEth(address author) public view returns (uint256) {
        return paidEth[author];
    }
}
