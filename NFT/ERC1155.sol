/*
NFT 是 Non-Fungible Token 的缩写，也就是非同质化代币，它是一种使用区块链技术创建的独特的数字资产。

根据 NFT 应用场景的不同制定了多个合约标准，比如 ERC721、ERC1155、ERC3475、ERC3525 等等。

其中，ERC721 是以太坊上使用最为广泛的 NFT 标准，其次就是 ERC1155 标准。

我用两个简单例子来说明 ERC1155 和 ERC721 的不同之处：

我们可以使用 ERC721 对数字艺术品进行代币化，每个艺术品都是独一无二的，拥有自己的独特标识符和特征。ERC721 NFT 与名画类似，每幅数字艺术品都是独特的，无论是从价值还是内容上都不相同。

我们可以使用 ERC1155 对游戏道具进行代币化，游戏中包括不同类型的游戏道具，比如剑、盾牌和药水。每一类道具都有自己的 tokenId，同时，每一类道具在数量上都不止一个，而是会有多个。所以，ERC1155 NFT  既拥有唯一的 tokenId，每个 tokenId 下又拥有一定的数量，兼具非同质化和同质化的双重特性。

1. ERC1155 和 ERC721 的区别
ERC1155 和 ERC721 都是以太坊的代币标准，主要用于非同质化代币，但它们在功能和使用场景上有一些关键的区别。

ERC721 标准
ERC721 标准中的每个代币都有独特的属性和标识符。这意味着每个 ERC721 代币都是唯一的，不能互换。

使用场景：

常用于艺术品、收藏品等领域，其中每个代币代表一个独特的、不可替代的资产。

主要特点：

每个代币都有唯一的ID。
更适用于独一无二的资产。
相对于 ERC1155 来说，交易成本可能更高，因为每次转移或交易都是单独处理的。
ERC1155 标准
ERC1155 是一个多代币标准，支持在同一个合约中创建多种类型的代币，每一类型的代币又有多个。

使用场景：

适用于需要管理多种类型代币的场景，如游戏中的多种物品（可交换代币、装备、卡片等），或者任何需要同时处理多种资产类型的平台。

主要特点：

支持创建多种代币类型。
交易效率更高，可以在一个交易中同时处理多个代币的转移。
减少了交易次数和 Gas 成本，尤其在需要批量处理多种代币时。
总的来说，ERC721 更适合代表独一无二的资产，如单一的艺术品或收藏品，而 ERC1155 则提供了更大的灵活性和效率，特别是在需要处理多种类型代币的场景中，例如复杂的游戏系统或代币化平台。

2. ERC1155 标准和接口
ERC1155 是一种代币标准，用于在以太坊上创建可代表多种类型资产的合约。

ERC1155 标准旨在为代表多种类型资产的合约提供统一的接口，使其能够创建、管理和转移多个不同类型的代币。它提供了一种更高效的方式来处理同一合约中的多个代币类型，减少了 Gas 费用和复杂性。

// ERC1155 标准接口
interface IERC1155 {
    // 查询账户 `account` 持有的 `id` 代币数量
    function balanceOf(address account, uint256 id) 
      external view returns (uint256);

    // 查询一组账户 `accounts` 持有的对应代币类型 `ids` 的数量
    function balanceOfBatch(address[] calldata accounts, 
      uint256[] calldata ids) 
      external view returns (uint256[] memory);

    // 授权操作者 `operator` 执行账户 `account` 所有代币的转移
    function setApprovalForAll(address operator, 
      bool approved) external;

    // 检查操作者 `operator` 是否被授权执行账户 `account` 所有代币的转移
    function isApprovedForAll(address account, address operator) 
      external view returns (bool);

    // 安全地将 `amount` 数量的代币 `id` 从 `from` 账户转移到 `to` 账户
    function safeTransferFrom(address from, 
      address to, 
      uint256 id, 
      uint256 amount, 
      bytes calldata data) external;

    // 安全地将一组代币 `ids` 对应的数量 `amounts` 从 `from` 账户批量转移到 `to` 账户
    function safeBatchTransferFrom(address from, 
      address to, uint256[] calldata ids, 
      uint256[] calldata amounts, 
      bytes calldata data) external;

    // 代币转移事件
    event TransferSingle(address indexed operator, 
      address indexed from, 
      address indexed to, 
      uint256 id, 
      uint256 value);

    // 批量代币转移事件
    event TransferBatch(address indexed operator, 
      address indexed from, 
      address indexed to, 
      uint256[] ids, 
      uint256[] values);

    // 授权事件
    event ApprovalForAll(address indexed account, 
      address indexed operator, 
      bool approved);
}
ERC1155 接口函数定义了 ERC1155 合约应该实现的基本功能，以便代币的管理和使用，它允许查询账户的代币余额、批量查询多个账户的多种代币余额、授权他人转移代币、检查授权状态，并安全地进行单个或批量的代币转移操作。

ERC1155 接口事件通常在代币转移、批量转移或授权操作时触发，提供了更多的信息和透明度。这些事件使得外部系统或用户界面能够监听和响应代币转移或授权操作，以保持状态同步并提供更好的用户体验。

3.  实现 ERC1155 合约
编写一个 ERC1155 合约就必须全部实现 IERC1155 的接口。

这是一项略微复杂的工作，您可以查看 openzepplin 代码库实现的合约代码，链接地址为：ERC1155.sol。

我们编写的 ERC1155 合约可以直接继承 openzepplin 代码库的 ERC1155 合约。

ERC1155 NFT 合约的示例：
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC1155Demo is ERC1155, Ownable {
    // 引入用于处理字符串的库
    using Strings for uint256;

    // 代币名称
    string constant _name = "BinSchool NFT"; 
    // 代币符号
    string constant _symbol = "BSNFT"; 
   // 用于拼接URI的基础部分
    string constant _baseURI = "https://binschool.app/";

    // 构造函数，初始化ERC1155和Ownable合约
    constructor() ERC1155("") Ownable(msg.sender) {
    }
    // 返回代币名称
    function name() public pure returns (string memory) {
        return _name;
    }
    // 返回代币符号
    function symbol() public pure returns (string memory) {
        return _symbol;
    }
    // 铸造新的代币并将其分发到指定账户，只允许合约所有者调用
    function mint(address to, uint256 id, uint256 value) 
      external onlyOwner {
        _mint(to, id, value, "");
    }
    // 获取特定ID的代币的元数据URI
    function uri(uint256 id) public pure override 
      returns (string memory) {
        return string(abi.encodePacked(_baseURI, id.toString(), ".json"));
    }
}