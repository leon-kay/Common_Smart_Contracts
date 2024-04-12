/*
智能合约中的 Bitmap ，中文翻译为“位图”，它不是指一种图片格式，而是指一种数据结构。

它利用内存中一段连续的二进制位 bit，来紧凑地存储大量的布尔值或状态信息，并且可以通过位运算来高效地进行操作和查询。

通过 Bitmap 来存储大量的布尔值或状态信息，最大的好处就是可以节省 gas，降低插槽存储的使用费用。

比如，在智能合约中，需要记录大量的地址是否已经领取 NFT。

我们通常可以使用一个 mapping 类型的状态变量，来记录领取情况。

mapping (address => bool) public _claimed;
这种情况下，每一个领取 NFT 的地址就需要在 mapping 中插入一个键值对，就会在 EVM 中产生一个存储插槽。

存储插槽的成本是非常高的，如果有几万个地址来领取，那么就会产生巨额费用。

但是，如果使用 Bitmap  来存储这个状态，那么存储费用却只有原来的千分之四。
1. 使用场景
在智能合约中，Bitmap 通常用于处理需要大量布尔值的场景，下面是一些常用案例：

投票系统
利用 Bitmap 可以高效地记录选民是否已经投票，而每个选民只需要使用一个位 bit 来表示。

权限管理
在需要精细权限控制的合约中，Bitmap 可以用来表示不同用户对于不同资源的访问权限。Bitmap 中的每一数据位 bit，都可以代表一个特定的权限，如读、写或执行权限。

状态标记
对于那些需要跟踪大量对象状态的应用程序，如游戏中的多个物品是否被捡起，或者多个任务是否完成，Bitmap 可以有效地存储这些状态信息。

资源分配
在资源管理和分配系统中，Bitmap 可以用来跟踪哪些资源被占用，哪些资源是可用的。比如，在 NFT 合约中，可以使用 Bitmap 来表示每一个 NFT 是否被领取。

Bitmap 通常使用一个 uint256 整数的每一位来代表一个布尔值。

uint256 整数共有 256 位，所以，可以代表 256 个状态或者标志。用某位的值 0 或 1，来表示某个状态或标志是否存在。

通过位运算，可以对特定的位进行设置、清除、翻转和查询操作，以实现对状态的管理和判断。

代码如下：
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library BitMaps {
    // 定义结构体BitMap，包含一个映射（mapping）字段 _data。
    // 这个映射的键（key）是一个 uint256 类型的数，代表“桶（bucket）”，
    // 它的值（value）也是 uint256 类型，用于存储位标记的实际数据。
    // _data 使用 uint256 作为位图存储，每个 uint256 可以存储256个状态
    struct BitMap {
        mapping(uint256 bucket => uint256) _data;
    }

    // 设置某个序号 index 的状态为 true
    function set(BitMap storage bitmap, uint256 index) public {
       // 计算在哪个桶里
        uint256 bucket = index / 256; 
        // 计算在桶里uint256的哪一位上
        uint256 bit = index % 256; 
        // 将对应的位设为1
        bitmap._data[bucket] |= (1 << bit); 
    }

    // 获取某个索引的状态
    function get(BitMap storage bitmap, uint256 index) 
        public view returns(bool) {
        // 计算在哪个桶里
        uint256 bucket = index / 256; 
        // 计算在桶里uint256的哪一位上
        uint256 bit = index % 256; 
        // 计算用于测试的掩码
        uint256 mask = (1 << bit); 
        //使用位与操作符(&)来检查对应位的状态
        return (bitmap._data[bucket] & mask) != 0; 
    }
}

/* 
3. 使用方法
我们可以在合约中，引入 BitMaps 库合约，然后使用 using for 将库函数应用到 BitMaps.BitMap 类型。

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./BitMaps.sol";

// 导入 BitMaps 库合约
contract BitmapClaim {
    // 使用 BitMaps 库中的 BitMap 结构
    using BitMaps for BitMaps.BitMap;
    // 声明一个私有的 BitMap 类型变量 _claimed
    BitMaps.BitMap private _claimed;

    // 领取编号为 index 的 NFT
    function claim(uint256 index) external  {
        // 要求当前编号对应的位未被设置（为 false）
        require(!_claimed.get(index), "You have already claimed!");
        // 设置当前编号对应的位为 true
        _claimed.set(index);
    }

    // 查询编号为 index 的 NFT 是否被领取
    function isClaimed(uint256 index) external view returns(bool)  {
        // 返回编号为 index 对应的位是否被设置
        return _claimed.get(index);
    }
}
在 openzepplin 中就有一个已经实现的 Bitmap 库合约，我们可以直接引入使用。示例代码如下：

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import  "@openzeppelin/contracts/utils/structs/BitMaps.sol";

contract BitmapClaim {
    using BitMaps for BitMaps.BitMap;
    BitMaps.BitMap private _claimed;

    // 领取编号为 index 的NFT
    function claim(uint256 index) external  {
        require(!_claimed.get(index), "You have already claimed!");
        _claimed.set(index);
    }

    // 查询编号为 index 的NFT是否被领取
    function isClaimed(uint256 index) external view returns(bool)  {
        return _claimed.get(index);
    }
}
*/
