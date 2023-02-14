// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Blog {
    // address owner;
    mapping(address => uint256) paidEth;

    struct PostData {
        string imageUrl;
        string assetId;
        string playbackId;
        string text;
        string[] tags;
    }

    mapping(address => uint256[]) postsByAuthor;
    mapping(uint256 => PostData) public posts;
    uint256 postId;

    event PostAdded(
        uint256 indexed postId,
        string[] indexed tags,
        address author,
        uint256 value
    );
    event AuthorRewarded(address indexed author, uint256 reward);

    // constructor() {
    //     owner = msg.sender;
    // }

    function greet() public pure returns (string memory) {
        return "This is a blog!";
    }

    function post(
        string memory _imageUrl,
        string memory _assetId,
        string memory _playbackId,
        string memory _text,
        string[] memory _tags
    ) public payable {
        require(msg.value > 0, "You must pay some ETH to post content");
        paidEth[msg.sender] += msg.value;
        postId++;
        postsByAuthor[msg.sender].push(postId);
        posts[postId] = PostData({
            imageUrl: _imageUrl,
            assetId: _assetId,
            playbackId: _playbackId,
            text: _text,
            tags: _tags
        });
        emit PostAdded(postId, _tags, msg.sender, msg.value);

        // Notify the author using the push protocol
        // ...
    }

    function getMyPosts() public view returns (PostData[] memory) {
        uint256[] memory _postIds = postsByAuthor[msg.sender];
        PostData[] memory result = new PostData[](_postIds.length);
        for (uint256 i = 0; i < _postIds.length; i++) {
            result[i] = posts[_postIds[i]];
        }
        return result;
    }

    function getAllPosts() public view returns (PostData[] memory) {
        PostData[] memory result = new PostData[](postId);
        for (uint256 i = 1; i <= postId; i++) {
            result[i - 1] = posts[i];
        }
        return result;
    }

    function getAllPostsByCount(uint256 postCount)
        public
        view
        returns (PostData[] memory)
    {
        PostData[] memory result = new PostData[](postCount);
        for (uint256 i = 0; i < postCount; i++) {
            result[i] = posts[i];
        }
        return result;
    }

    function getPostById(uint256 _postId)
        public
        view
        returns (PostData memory)
    {
        return posts[_postId];
    }

    function getPostsByIds(uint256[] memory _postIds)
        public
        view
        returns (PostData[] memory)
    {
        PostData[] memory result = new PostData[](_postIds.length);
        for (uint256 i = 0; i < _postIds.length; i++) {
            result[i] = posts[_postIds[i]];
        }
        return result;
    }

    function getLatestPosts() public view returns (PostData[] memory, uint256) {
        uint256 latestPostId = postId;
        if (latestPostId > 5) {
            latestPostId = latestPostId - 5;
        } else {
            latestPostId = 1;
        }
        uint256 postCount = postId - latestPostId + 1;
        PostData[] memory result = new PostData[](postCount);
        for (uint256 i = 0; i < postCount; i++) {
            result[i] = posts[latestPostId + i];
        }
        return (result, postId);
    }

    function rewardAuthor(address payable author, uint256 reward)
        public
        payable
    {
        require(
            msg.value >= reward,
            "The reward must be equal to or less than the sent ETH"
        );
        require(
            author != address(0),
            "The author address must be a valid Ethereum address"
        );
        author.transfer(reward);
        emit AuthorRewarded(author, reward);

        // Notify the author using the push protocol
        // ...
    }

    function getPaidEth(address author) public view returns (uint256) {
        return paidEth[author];
    }

    function withdrawFunds() public {
        uint256 paid = paidEth[msg.sender];
        require(paid > 0, "No funds available for withdrawal");
        paidEth[msg.sender] = 0;
        payable(msg.sender).transfer(paid);
    }
}
