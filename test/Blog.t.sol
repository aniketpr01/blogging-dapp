// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/StdAssertions.sol";

import "src/Blog.sol";

contract BlogTest is Test {
    Blog blog;

    function setUp() public {
        blog = new Blog();
    }

    function testGreet() public {
        string memory expected = "This is a blog!";
        string memory result = blog.greet();
        assertEq(result, expected);
        // assertEq(1 == 1);
    }

    function testPost() public {
        string memory imageUrl = "https://example.com/image.jpg";
        string memory assetId = "asset-123";
        string memory playbackId = "playback-456";
        string memory text = "Hello, World!";
        string[] memory tags = new string[](3);
        tags[0] = "test";
        tags[1] = "blog";
        tags[2] = "post";

        // blog.post(imageUrl, assetId, playbackId, text, tags);

        blog.post{value: 1 ether}(imageUrl, assetId, playbackId, text, tags);

        Blog.PostData memory post = blog.getPostById(1);
        assertEq(post.imageUrl, imageUrl);
        assertEq(post.assetId, assetId, "assetId should be 'asset-123'");
        assertEq(
            post.playbackId,
            playbackId,
            "playbackId should be 'playback-456'"
        );
        assertEq(post.text, text, "text should be 'Hello, World!'");

        // assertEq(post.tags, tags, "tags should be ['test', 'blog', 'post']");
        assertEq(post.tags.length, tags.length);
        for (uint256 i = 0; i < tags.length; i++) {
            string memory expectedTag = tags[i];
            string memory actualTag = post.tags[i];
            assertEq(
                keccak256(abi.encodePacked(expectedTag)),
                keccak256(abi.encodePacked(actualTag)),
                "tags should match"
            );
        }
    }

    function testGetMyPosts() public {
        string memory imageUrl = "https://example.com/image.jpg";
        string memory assetId = "asset-123";
        string memory playbackId = "playback-456";
        string memory text = "Hello, World!";
        string[] memory tags = new string[](3);
        tags[0] = "test";
        tags[1] = "blog";
        tags[2] = "post";

        blog.post{value: 1 ether}(imageUrl, assetId, playbackId, text, tags);

        Blog.PostData[] memory result = blog.getMyPosts();
        assertEq(result.length, 1, "result should have a length of 1");

        Blog.PostData memory post = result[0];
        assertEq(
            post.imageUrl,
            imageUrl,
            "imageUrl should be 'https://example.com/image.jpg'"
        );
        assertEq(post.assetId, assetId, "assetId should be 'asset-123'");
        assertEq(
            post.playbackId,
            playbackId,
            "playbackId should be 'playback-456'"
        );
        assertEq(post.text, text, "text should be 'Hello, World!'");
        // assertEq(post.tags, tags, "tags should be ['test', 'blog', 'post']");
        assertEq(post.tags.length, tags.length);
        for (uint256 i = 0; i < tags.length; i++) {
            string memory expectedTag = tags[i];
            string memory actualTag = post.tags[i];
            assertEq(
                keccak256(abi.encodePacked(expectedTag)),
                keccak256(abi.encodePacked(actualTag)),
                "tags should match"
            );
        }
    }

    function testGetAllPosts() public {
        // Given
        // Blog blog = new Blog();
        string memory imageUrl = "image.png";
        string memory assetId = "asset1";
        string memory playbackId = "playback1";
        string memory text = "This is a post";
        string[] memory tags = new string[](2);
        tags[0] = "tag1";
        tags[1] = "tag2";

        blog.post{value: 1 ether}(imageUrl, assetId, playbackId, text, tags);
        blog.post{value: 2 ether}(imageUrl, assetId, playbackId, text, tags);

        // When
        Blog.PostData[] memory result = blog.getAllPosts();

        // Then
        assertEq(result.length, 2, "Incorrect number of posts");
        assertEq(result[0].text, text, "Incorrect post text");
        assertEq(result[0].tags[0], tags[0], "Incorrect tag");
        assertEq(result[0].tags[1], tags[1], "Incorrect tag");
        assertEq(result[1].text, text, "Incorrect post text");
        assertEq(result[1].tags[0], tags[0], "Incorrect tag");
        assertEq(result[1].tags[1], tags[1], "Incorrect tag");
    }

    function testGetLatestPosts() public {
        // Given
        // Blog new_blog = new Blog();
        // address payable author1 = payable(address(1));
        // address payable author2 = payable(address(2));
        string memory imageUrl = "image.png";
        string memory assetId = "asset1";
        string memory playbackId = "playback1";
        string memory text = "This is a post";
        string[] memory tags = new string[](2);
        tags[0] = "tag1";
        tags[1] = "tag2";

        blog.post{value: 1 ether}(imageUrl, assetId, playbackId, text, tags);
        blog.post{value: 1 ether}(imageUrl, assetId, playbackId, text, tags);
        blog.post{value: 2 ether}(imageUrl, assetId, playbackId, text, tags);
        blog.post{value: 1 ether}(imageUrl, assetId, playbackId, text, tags);

        // When
        Blog.PostData[] memory result = blog.getMyPosts();

        // emit log(result[0]);

        // Then
        assertEq(result.length, 4, "Incorrect number of posts");
        assertEq(result[0].text, text, "Incorrect post text");
        assertEq(result[0].tags[0], tags[0], "Incorrect tag");
        assertEq(result[0].tags[1], tags[1], "Incorrect tag");
        assertEq(result[1].text, text, "Incorrect post text");
        assertEq(result[1].tags[0], tags[0], "Incorrect tag");
        assertEq(result[1].tags[1], tags[1], "Incorrect tag");
    }

    function testGetPostsByIds() public {
        // Blog new_blog = new Blog();
        uint256[] memory postIds = new uint256[](3);
        postIds[0] = 1;
        postIds[1] = 2;
        postIds[2] = 3;

        // Add some posts
        blog.post{value: 1 ether}(
            "url1",
            "asset1",
            "playback1",
            "text1",
            new string[](0)
        );
        blog.post{value: 1 ether}(
            "url2",
            "asset2",
            "playback2",
            "text2",
            new string[](0)
        );
        blog.post{value: 1 ether}(
            "url3",
            "asset3",
            "playback3",
            "text3",
            new string[](0)
        );

        // Get the posts by ids
        Blog.PostData[] memory result = blog.getPostsByIds(postIds);

        // Assert the post data is correct
        assertEq(result[0].imageUrl, "url1", "Incorrect image url for post 1");
        assertEq(result[1].imageUrl, "url2", "Incorrect image url for post 2");
        assertEq(result[2].imageUrl, "url3", "Incorrect image url for post 3");
        assertEq(result[0].assetId, "asset1", "Incorrect asset id for post 1");
        assertEq(result[1].assetId, "asset2", "Incorrect asset id for post 2");
        assertEq(result[2].assetId, "asset3", "Incorrect asset id for post 3");
        assertEq(
            result[0].playbackId,
            "playback1",
            "Incorrect playback id for post 1"
        );
        assertEq(
            result[1].playbackId,
            "playback2",
            "Incorrect playback id for post 2"
        );
        assertEq(
            result[2].playbackId,
            "playback3",
            "Incorrect playback id for post 3"
        );
        assertEq(result[0].text, "text1", "Incorrect text for post 1");
        assertEq(result[1].text, "text2", "Incorrect text for post 2");
        assertEq(result[2].text, "text3", "Incorrect text for post 3");
    }
}
