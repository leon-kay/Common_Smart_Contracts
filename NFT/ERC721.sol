/*
NFT 是 Non-Fungible Token 的缩写，也就是非同质化代币，它是一种使用区块链技术创建的独特的数字资产。

NFT 虽然也是一种代币，但与 ERC20 代币并不相同。ERC20 代币是一种同质化代币，其中的任何一个代币都相同，没有区别，是可以互换的。而 NFT 中的每一个代币则是独一无二的，不可替换。

我们用一个简单例子来说明“同质化代币”和“非同质化代币”的不同。

比如：日常使用的货币是“同质化”的，任何的一元纸币，从价值到外观都是一样的，是可以互换的。而名画则是“非同质化”的，每一张名画都是独一无二的，无论价值还是内容都是不一样的。

1. NFT和同质化代币的区别
1）唯一性
NFT 是非同质化的，每个代币都是独特的，有其特定的属性和价值。

而同质化代币则是可互换的，每个单位的代币都是相同的。

2）所有权和真实性
NFT 通过区块链技术提供了它所代表的独特资产的所有权和真实性的证明，这个证明是不可篡改的。

而同质化代币只用于价值衡量和交换媒介。

3）应用场景
NFT 用于代表数字艺术品、收藏品、数字版权、游戏物品，甚至是房地产或其它独特资产的所有权。

而同质化代币则多用于交易、支付和金融服务。

2. ERC721 标准
根据 NFT 应用场景的不同，在以太坊区块链上制定了多个合约标准，比如 ERC721、ERC1155、ERC3475、ERC3525 等等。其中，ERC721 是以太坊上使用最为广泛的 NFT 标准。

ERC721 标准是在 2017 年提出的，它定义了一系列智能合约的接口，专门用于管理 NFT 的唯一标识和所有权。这个标准确保了每一个 NFT 都是独特的，并且可以独立追踪和交易。只有遵循 NFT 标准的智能合约，才可以在各种钱包、交易平台和应用程序中被识别和交易。

对于从事 Web3 行业的任何人员，都应该了解并掌握 ERC721 NFT 的智能合约。NFT 不仅为数字艺术、收藏品和其它资产的所有权提供了一种新方式，也为去中心化世界中的资产所有权带来了革命性的变革。

ERC721 标准定义了一套必需和可选的方法以及事件，使得 NFT 可以在不同应用程序和钱包间通用。

3. ERC721 必须实现的接口
1）IERC721 接口
interface IERC721 {
    // 转账事件
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    // 授权事件
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    // 全部授权事件
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // 查询余额函数
    function balanceOf(address owner) external view returns (uint256 balance);
    // 查询所有者函数
    function ownerOf(uint256 tokenId) external view returns (address owner);
    // 转移函数
    function transferFrom(address from, address to, uint256 tokenId) external;
    // 安全转移函数
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    // 安全转移函数，可以携带数据
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    // 授权函数
    function approve(address to, uint256 tokenId) external;
    // 查询授权函数
    function getApproved(uint256 tokenId) external view returns (address operator);
    // 全部授权函数
    function setApprovalForAll(address operator, bool _approved) external;
    // 查询全部授权函数
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}
2）接口函数说明
balanceOf 查询余额函数
返回指定地址拥有 NFT 的数量。

ownerOf 查询所有者函数
返回指定 NFT 的所有者地址。

transferFrom 转移函数
用于将指定 NFT 从一个地址转移到另一个地址。

safeTransferFrom 安全转移代币函数
这个函数在转移代币时增加了安全检查，确保接收方能够处理 ERC721 NFT。

接口中共有2个这样的同名函数，其中一个可以携带任意的 data 数据。

approve 授权函数
用于授权指定地址操作拥有者某个特定的 NFT。

getApproved 查询授权函数
返回指定 NFT 被授权给哪个地址。

setApprovalForAll 全部授权函数
用于授权指定地址操作拥有者的所有 NFT。

isApprovedForAll 查询全部授权函数
它用来查询拥有者的 NFT 是否全部授权给特定地址操作。

3）接口事件说明
Transfer 转账事件
当 NFT 从一个地址转移到另一个地址时触发。

Approval 授权事件
当 NFT 的授权状态发生变化时触发。

ApprovalForAll 全部授权事件
当 NFT 的全部授权状态发生变化时触发。

4. ERC721 可选实现的函数和事件
ERC721 智能合约除了必须实现的接口外，还定义了几个可以选择实现的扩展接口。

在所有可选的接口中，通常都会实现一个称为“元数据接口”的 ERC721Metadata。

元数据接口的作用是用于返回 NFT 名称、符号以及特定编号的 NFT 的详细信息。

元数据接口 ERC721Metadata 的定义如下：

interface IERC721Metadata {
    // 返回 NFT 的名称
    function name() external view returns (string memory);
    // 返回 NFT 的符号
    function symbol() external view returns (string memory);
   // 返回指定编号的 NFT 的元数据
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
特定编号的 NFT 的元数据，是指它所代表的资产的详细信息。元数据是一种标准化的 JSON 格式数据，通常包含特定编号 NFT 的名称、描述、图像链接，以及其它属性。

以下就是一个 NFT 的元数据：

{
    "name": "BinSchool NFT",
    "description": "An exclusive digital artwork created by BinSchool",
    "image": "https://binschool.app/nft/1.png",
    "attributes": [
        {
            "trait_type": "Background",
            "value": "Sunset"
        },
        {
            "trait_type": "Color",
            "value": "Blue"
        },
        {
            "trait_type": "Size",
            "value": "Large"
        }
    ]
}
这个元数据 JSON 文件的内容如下：

name
特定编号的 NFT 的名称。

description
特定编号的 NFT 的描述，通常是关于艺术品或收藏品的信息。

image
特定编号的 NFT 图片的 URL，通常是艺术品或收藏品的图片链接。

attributes
一系列关于特定编号的 NFT 的特质或属性。这些可以包括颜色、大小、背景等。

我们可以通过 ERC721Metadata 中的 tokenURI 函数，查询到特定编号的 NFT 的元数据 URL，比如：返回的元数据链接为 https://binschool.app/nft/1.json。

5.  实现 ERC721 合约
编写一个 ERC721 合约就必须全部实现 IERC721 的接口，通常也要实现可选接口 IERC721Metadata。

这是一项略微复杂的工作，您可以查看 openzepplin 代码库实现的合约代码，链接地址为：ERC721.sol。

我们自己编写 ERC721 合约时，可以直接继承 openzepplin 代码库的 ERC721 合约。

ERC721 NFT 合约的示例：
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 引入 openzeppelin ERC721 合约
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// 引入权限控制合约
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721Demo is ERC721, Ownable {
    // NFT 编号，从1开始，自动累加
    uint256 public tokenId; 
    // tokenId 到对应 tokenURI 的映射
    mapping(uint256 => string) tokenURIs; 

    // 构造函数
    constructor() ERC721("BinSchool NFT", "BSNFT") Ownable(msg.sender) {
      // NFT名称为"BinSchool NFT"，符号为"BSNFT"
      // 将合约部署者设为合约所有者
    }

    /**
     * @dev 铸造新的NFT并将其分配给指定地址。
     * @param _to 接收新NFT的地址。
     * @param _tokenURI 代表新NFT元数据的URI。
     */
    function mint(address _to, string memory _tokenURI) external onlyOwner {
      // 铸造新的NFT并分配给指定地址
      // 新NFT编号为上一个的编号加1
      _mint(_to, ++tokenId); 
      // 关联tokenURI 到 tokenId
      tokenURIs[tokenId] = _tokenURI;  
    }

    /**
     * @dev 获取给定 tokenId 的 tokenURI。
     * @param _tokenId 要获取URI的token的ID。
     */
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
      // 返回指定 tokenId 的 tokenURI
      return tokenURIs[_tokenId]; 
    }
}