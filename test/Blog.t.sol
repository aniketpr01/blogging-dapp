// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Blog.sol";

contract BlogTest is Test {
    Blog blog;

    function setUp() public {
        blog = new Blog();
    }

    function test1() public {
        assertEq(blog.greet(), "This is a blog!");
    }

    // function test2() public {
    //     assertEq(hello.version(), 0);
    //     hello.updateGreeting("Hello World");
    //     assertEq(hello.version(), 1);
    //     string memory value = hello.greet();
    //     emit log(value);
    //     assertEq(hello.greet(), "Hello World");
    // }
}
