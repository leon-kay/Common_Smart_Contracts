/*
Solidity 语言中并没有专门处理字符串的标准函数，有时候使用起来非常不方便。

比如，在某些场景下，我们需要获得字符串的长度，比较字符串是否相同，以及将整型、地址型数据转换为字符串等。

1. Strings 库函数说明
在 openzepplin 中，提供了一个专门的 Strings 库合约，方便对字符串进行处理。

以下为 Strings 库函数的函数说明：

library Strings {
    // 将一个 uint256 类型的数值转为字符串
    function toString(uint256 value) internal pure returns (string memory);
    // 将一个 int256 类型的数值转为字符串
    function toStringSigned(int256 value) internal pure returns (string memory);
    // 将一个 uint256 类型的数值，转为16进制表示的字符串
    function toHexString(uint256 value) internal pure returns (string memory);
    // 将一个 uint256 类型的数值，转为16进制表示的固定长度的字符串
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory);
    // 将一个 address 类型的数值，转为16进制表示的字符串
    function toHexString(address addr) internal pure returns (string memory);
    // 比较两个字符串是否相等
    function equal(string memory a, string memory b) internal pure returns (bool);
}
在 Strings 库中没有专门获取字符串长度的函数，但我们可以通过变通方式获得字符串的长度。

比如，获取一个字符串的长度，可以先将其转为字节类型，再取字节类型的长度。

bytes("binschool.app").length
另外，如果要把 uint8 转为字符串，可以先将其转为 uint256，再通过 Strings 库提供的函数进行转换。

2. Strings 库函数使用
使用 Strings 也非常简单。我们可以在合约中，引入 Strings 库合约，然后使用 using for 将库函数应用到 uint256 或者 address 类型。

示例如下：
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";

contract StringsDemo  {
    // 将库函数应用到 uint256 类型
    using Strings for uint256;
    // 将库函数应用到 string 类型
    using Strings for string;

    // 将 uint256 转为字符串
    function getString(uint256 value) external pure returns(string memory) {
        return value.toString();
    }
    // 将 uint256 转为16进制表示的字符串
    function getHexString(uint256 value) external pure returns(string memory) {
        return value.toHexString();
    }
    // 将 uint256 转为长度为5个字节的16进制表示的字符串
    function getFiexedHexString(uint256 value) external pure returns(string memory) {
        return value.toHexString(5);
    }
    // 判断两个字符串是否相同
    function equals(string memory s1, string memory s2) external pure returns(bool) {
        return s1.equal(s2);
    }
}
