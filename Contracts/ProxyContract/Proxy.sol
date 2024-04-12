/*
代理合约（Proxy Contract）是一种特殊的智能合约，调用者可以通过其提供的接口与目标智能合约进行交互。目标合约通常称为逻辑合约或者实现合约。

代理合约位于调用者和目标合约之间，起到类似中介的作用。

代理合约的工作原理主要依赖于区块链的消息调用机制。当一个代理合约收到消息调用时，它可以将该消息调用转发给另一个合约，即逻辑合约。

1. 代理合约的使用场景
1.1 实现可升级性
可以实现用户无感的情况下平滑升级逻辑合约，来增加逻辑合约的新功能或者修复漏洞。

1.2 实现权限控制
可以在代理合约中为用户设定操作权限，确保用户按照授权执行允许的操作。

1.3 实现审计功能
可以在代理合约中记录关键操作，便于日后进行安全审计和监控，确保合约使用的安全性和可追溯性。

代理合约最常使用的场景还是实现可升级合约，我们将会在下一章节详解讲解。

2.  代理合约的实现
在代理合约中，需要保存一个指向逻辑合约的地址。当调用者向代理合约提交请求时，代理合约将请求转发给逻辑合约，并将执行结果返回给调用者。

那么，代理合约如何将请求转发给逻辑合约呢？

我们在基础教程中介绍过回退函数 fallback 的工作机制：如果有人调用了一个合约中不存在的函数，那么将自动执行合约中的 fallback 函数。

因此，只要在代理合约中不定义处理业务逻辑的函数，那么外部的调用请求就会转给 fallback 函数，我们在 fallback 函数中再把请求转给逻辑合约。

2.1 代理合约 Proxy 的实现代码
// 代理合约
contract Proxy {
    // 逻辑合约地址
    address public logicContractAddress;

    // 构造函数
    constructor(address _logicContractAddress) {
        // 设置逻辑合约地址
        logicContractAddress = _logicContractAddress;
    }
    // 调用逻辑合约的 fallback 函数
    fallback() external {
        // 转发请求给逻辑合约
        (bool success, bytes memory result) = logicContractAddress.call(msg.data);
        require(success, "Forwarding request to logic contract failed");
        // 返回执行结果给调用者
        assembly {
            return(add(result, 0x20), mload(result))
        }
    }
}
说明： 代理合约 Proxy 中的 fallback 函数将接收到的请求转发给逻辑合约，并将执行结果返回给调用者。

2.2 逻辑合约 Logic 的实现代码
// 逻辑合约
contract Logic {
    // 业务逻辑实现
    function foo() external pure returns (uint) {
        // 实现具体的业务逻辑
        return 1024;
    }
}
说明： 逻辑合约中定义了一个函数 foo，它返回整型值 1024。

2.3 调用合约 Caller 的实现代码
// 调用合约
contract Caller {
    // 代理合约地址
    address public proxy; 

    // 设置代理合约地址
    constructor(address _proxy){
        proxy = _proxy;
    }
    // 通过代理合约调用 foo 函数
    function foo() external returns(bool, uint) {
        // 使用 call 方法，传入 foo 函数签名
        (bool success, bytes memory data) = proxy.call(abi.encodeWithSignature("foo()"));
        // 将代理返回的结果进行解码
        return (success, abi.decode(data,(uint)));
    }
}
说明： 调用合约 Caller 中的 foo 函数将通过代理合约 Proxy，调用逻辑合约 Logic 的 foo 函数。
*/