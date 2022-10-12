# 合约地址

- token代币:			0x6A2317
- lp代币				0x9fE04b51A
- nft销毁挖矿合约		0x849c25f0f
- lp质押挖矿合约		0xA45A813ECCaBf14986188A3
- 金库合约			0x5322076Ae767fb4A5cD0E
- wkto合约地址		0x3850D46e316c8788269
- nft合约地址			0xDD4Eeb288D88f9bA03
- nft申购合约			0xfD3Fb20f1aea19

## 文档
### NFT申购合约
### Interface
```json
pragma solidity >=0.6.12;

interface INFTMint {
    /**
    @dev    获取nft购买信息
     */
    function getNftInfo(uint256 _tokenId)
        external
        view
        returns (uint256 _price);

    /**
     @dev   修改nft的使用情况
      */
    function updateIsUsed(uint256 _tokenId) external;

    /**
    @dev 聚合函数
    - 用户token资产
    - 用户token授权金额
    - 用户是否已经申购nft
     */
    function argUser(address _user)
        external
        view
        returns (
            uint256 _balance,
            uint256 _allowance,
            bool _isMint
        );

    /**
    @dev 获取用户持有的nft的id列表
    @param  _user   用户地址
    @return  0      id数组
    @return  1      nft总数
     */
    function getUserAllNFT(address _user)
        external
        view
        returns (uint256[] memory, uint256);

    /**
    @dev 获取系统的信息
    - isActive      是否开启活动
    - price         价格
    - amount        可以出售的数量
    - totalMint     可用铸造数量
    - startTime     活动开始时间
     */
    function getActiveInfo()
        external
        view
        returns (
            bool _isActive,
            uint256 _price,
            uint256 _amount,
            uint256 _totalMint,
            uint64 _startTime
        );

    /**
    @dev   消耗代币铸造一个nft
     */
    function mintNFT() external;
}

```
#### ABI
```json
[
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_user",
				"type": "address"
			}
		],
		"name": "argUser",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_balance",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_allowance",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "_isMint",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getActiveInfo",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_isActive",
				"type": "bool"
			},
			{
				"internalType": "uint256",
				"name": "_price",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_totalMint",
				"type": "uint256"
			},
			{
				"internalType": "uint64",
				"name": "_startTime",
				"type": "uint64"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "getNftInfo",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_price",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_user",
				"type": "address"
			}
		],
		"name": "getUserAllNFT",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "",
				"type": "uint256[]"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "mintNFT",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "updateIsUsed",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]
```
### NFT质押合约
#### Interface
```json
pragma solidity >=0.6.12;

interface IDestory {
    /**
    @dev 用户订单结构体
    @param  amount  金额
    @param  time    质押时间
     */
    struct UserOrder {
        uint256 amount;
        uint256 time;
    }

    /**
    @dev 用户进行销毁,nft质押之后不能解押，直接进行销毁，只用记录用户销毁数量即可
    @param _tokenId 质押的nftId，需要提前授权
     */
    function deposit(uint256 _tokenId) external;

    /**
    @dev 用户领取当前可以领取的收益
     */
    function harvest() external;

    /**
    @dev 获取用户可以领取的收益
     */
    function pending(address _user) external view returns (uint256);

    /**
    @dev 聚合函数
    @param  _user       指定用户
    @return _isApprove   用户NFT的授权情况,是否已经全部授权
    @return _amount      用户的有效质押金额
    @return _received    用户已经领取的收益
    @return _pendingToken   用户当前可以领取的收益
    @return _nftTotal   用户质押的nft数量,
     */
    function argInfo(address _user)
        external
        view
        returns (
            bool _isApprove,
            uint256 _amount,
            uint256 _received,
            uint256 _pendingToken,
            uint256 _nftTotal
        );

    /**
    @dev 获取活动信息
    @return _startTime      活动开启时间，10位时间戳
    @return _cycle          活动锁仓周期,150就是150天
    @return _totalShare     质押总份额
    @return _useShare       质押已经使用的份额
     */
    function getActive()
        external
        view
        returns (
            uint256 _startTime,
            uint256 _cycle,
            uint256 _totalShare,
            uint256 _useShare
        );
}

```
#### ABI
```json
[
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_user",
				"type": "address"
			}
		],
		"name": "argInfo",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_isApprove",
				"type": "bool"
			},
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_received",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_pendingToken",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_nftTotal",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "deposit",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getActive",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_startTime",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_cycle",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_totalShare",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_useShare",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "harvest",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_user",
				"type": "address"
			}
		],
		"name": "pending",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
```
### NFT(ERC721)
#### Interface
```
pragma solidity >=0.6.12;

interface IERC721 {
    /**
    @dev NFT 转账
    @return _from   从谁转出
    @return _to     转移给谁
    @return _tokenId   转账的tokenId
     */
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    //授权
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );
    /**
    @dev  全部授权
    @return _owner   授权操作人
    @return _operator     授权给谁
    @return _approved   是否授权可以操作，bool值
     */
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    /**
    @dev 从 _from 地址转移 _tokenId 到 _to 地址
     */
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata _data
    ) external;

    /**
    @dev 从 _from 地址转移 _tokenId 到 _to 地址
     */
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;

    /**
    @dev 从 _from 地址转移 _tokenId 到 _to 地址
    @param  _from   出账地址
    @param  _to     入账地址
    @param  _tokenId   转账TokenId
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;

    /**
    @dev    单个授权操作
    @param  _approved   授权给谁
    @param  _tokenId   可以操作的tokenID
     */
    function approve(address _approved, uint256 _tokenId) external;

    /**
    @dev    全部授权操作
    @param  _operator   授权给谁
    @param  _approved   是否授权的bool值
     */
    function setApprovalForAll(address _operator, bool _approved) external;

    /**
    @dev    获取指定地址的nft数量
    @param  _owner   指定地址
    @return  uint256   nft数量
     */
    function balanceOf(address _owner) external view returns (uint256);

    /**
    @dev    获取指定nft的拥有者
    @param  _tokenId   指定nft的tokenId
    @return  address   拥有者
     */
    function ownerOf(uint256 _tokenId) external view returns (address);

    function getApproved(uint256 _tokenId) external view returns (address);

    /**
    @dev 获取 _owner 是否已经对 _operator 进行授权全部
    @param  _owner   资产拥有者
    @param  _operator   可操作者
    @return  bool   是否授权
     */
    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool);
}

```
#### ABI
```
[
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_owner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "_approved",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "Approval",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_owner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "_operator",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "bool",
				"name": "_approved",
				"type": "bool"
			}
		],
		"name": "ApprovalForAll",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_from",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "_to",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "Transfer",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_approved",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "approve",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_owner",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "getApproved",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_owner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_operator",
				"type": "address"
			}
		],
		"name": "isApprovedForAll",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "ownerOf",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_from",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "safeTransferFrom",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_from",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_tokenId",
				"type": "uint256"
			},
			{
				"internalType": "bytes",
				"name": "_data",
				"type": "bytes"
			}
		],
		"name": "safeTransferFrom",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_operator",
				"type": "address"
			},
			{
				"internalType": "bool",
				"name": "_approved",
				"type": "bool"
			}
		],
		"name": "setApprovalForAll",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_from",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_tokenId",
				"type": "uint256"
			}
		],
		"name": "transferFrom",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]
```
### Token(ERC20)
#### Interface
```
// SPDX-License-Identifier: Unlicensed
pragma solidity >=0.6.12;

interface IDividendToken {
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
    @dev 返回指定地址的邀请上级
     */
    function inviter(address user) external view returns (address);
}


```
#### ABI
```
[
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			}
		],
		"name": "Approval",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			}
		],
		"name": "Transfer",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			}
		],
		"name": "allowance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "approve",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "user",
				"type": "address"
			}
		],
		"name": "inviter",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "recipient",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "transfer",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "sender",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "recipient",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "transferFrom",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]
```