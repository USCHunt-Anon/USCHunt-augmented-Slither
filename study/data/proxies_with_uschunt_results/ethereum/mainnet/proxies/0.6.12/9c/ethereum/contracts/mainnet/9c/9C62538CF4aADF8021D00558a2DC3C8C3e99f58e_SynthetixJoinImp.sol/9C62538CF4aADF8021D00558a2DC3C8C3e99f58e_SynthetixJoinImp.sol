/**
 *Submitted for verification at Etherscan.io on 2022-03-07
*/

// ////-License-Identifier: AGPL-3.0-or-later
pragma solidity =0.6.12;

////// src/CropJoin.sol
// Copyright (C) 2021 Dai Foundation
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* pragma solidity 0.6.12; */

contract CropJoin {
    address public implementation;
    mapping (address => uint256) public wards;
    uint256 public live;

    event Rely(address indexed usr);
    event Deny(address indexed usr);
    event SetImplementation(address indexed);

    modifier auth {
        require(wards[msg.sender] == 1, "CropJoin/not-authed");
        _;
    }

    constructor() public {
        wards[msg.sender] = 1;
        emit Rely(msg.sender);
        live = 1;
    }

    function rely(address usr) external auth {
        wards[usr] = 1;
        emit Rely(msg.sender);
    }

    function deny(address usr) external auth {
        wards[usr] = 0;
        emit Deny(msg.sender);
    }

    function setImplementation(address implementation_) external auth {
        implementation = implementation_;
        emit SetImplementation(implementation_);
    }

    fallback() external {
        address _impl = implementation;
        require(_impl != address(0));

        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
}

interface VatLike_14 {
    function urns(bytes32, address) external view returns (uint256, uint256);
    function dai(address) external view returns (uint256);
    function gem(bytes32, address) external view returns (uint256);
    function slip(bytes32, address, int256) external;
}

interface ERC20 {
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address dst, uint256 amount) external returns (bool);
    function transferFrom(address src, address dst, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function decimals() external returns (uint8);
}

// receives tokens and shares them among holders
contract CropJoinImp {
    bytes32 slot0;
    mapping (address => uint256) wards;
    uint256 live;

    VatLike_14     public immutable vat;    // cdp engine
    bytes32     public immutable ilk;    // collateral type
    ERC20       public immutable gem;    // collateral token
    uint256     public immutable dec;    // gem decimals
    ERC20       public immutable bonus;  // rewards token

    uint256     public share;  // crops per gem    [bonus decimals * ray / wad]
    uint256     public total;  // total gems       [wad]
    uint256     public stock;  // crop balance     [bonus decimals]

    mapping (address => uint256) public crops; // crops per user  [bonus decimals]
    mapping (address => uint256) public stake; // gems per user   [wad]

    uint256 immutable internal to18ConversionFactor;
    uint256 immutable internal toGemConversionFactor;

    // --- Events ---
    event Join(address indexed urn, address indexed usr, uint256 val);
    event Exit(address indexed urn, address indexed usr, uint256 val);
    event Flee(address indexed urn, address indexed usr, uint256 val);
    event Tack(address indexed src, address indexed dst, uint256 wad);

    modifier auth {
        require(wards[msg.sender] == 1, "CropJoin/not-authed");
        _;
    }

    constructor(address vat_, bytes32 ilk_, address gem_, address bonus_) public {
        vat = VatLike_14(vat_);
        ilk = ilk_;
        gem = ERC20(gem_);
        uint256 dec_ = ERC20(gem_).decimals();
        require(dec_ <= 18);
        dec = dec_;
        to18ConversionFactor = 10 ** (18 - dec_);
        toGemConversionFactor = 10 ** dec_;
        bonus = ERC20(bonus_);
    }

    function add(uint256 x, uint256 y) public pure returns (uint256 z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }
    function sub(uint256 x, uint256 y) public pure returns (uint256 z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }
    function mul(uint256 x, uint256 y) public pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }
    function divup(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(x, sub(y, 1)) / y;
    }
    uint256 constant WAD  = 10 ** 18;
    function wmul(uint256 x, uint256 y) public pure returns (uint256 z) {
        z = mul(x, y) / WAD;
    }
    function wdiv(uint256 x, uint256 y) public pure returns (uint256 z) {
        z = mul(x, WAD) / y;
    }
    function wdivup(uint256 x, uint256 y) public pure returns (uint256 z) {
        z = divup(mul(x, WAD), y);
    }
    uint256 constant RAY  = 10 ** 27;
    function rmul(uint256 x, uint256 y) public pure returns (uint256 z) {
        z = mul(x, y) / RAY;
    }
    function rmulup(uint256 x, uint256 y) public pure returns (uint256 z) {
        z = divup(mul(x, y), RAY);
    }
    function rdiv(uint256 x, uint256 y) public pure returns (uint256 z) {
        z = mul(x, RAY) / y;
    }

    // Net Asset Valuation [wad]
    function nav() public virtual view returns (uint256) {
        uint256 _nav = gem.balanceOf(address(this));
        return mul(_nav, to18ConversionFactor);
    }

    // Net Assets per Share [wad]
    function nps() public view returns (uint256) {
        if (total == 0) return WAD;
        else return wdiv(nav(), total);
    }

    function crop() internal virtual returns (uint256) {
        return sub(bonus.balanceOf(address(this)), stock);
    }

    function harvest(address from, address to) internal {
        if (total > 0) share = add(share, rdiv(crop(), total));

        uint256 last = crops[from];
        uint256 curr = rmul(stake[from], share);
        if (curr > last) require(bonus.transfer(to, curr - last));
        stock = bonus.balanceOf(address(this));
    }

    function join(address urn, address usr, uint256 val) public auth virtual {
        require(live == 1, "CropJoin/not-live");

        harvest(urn, usr);
        if (val > 0) {
            uint256 wad = wdiv(mul(val, to18ConversionFactor), nps());

            // Overflow check for int256(wad) cast below
            // Also enforces a non-zero wad
            require(int256(wad) > 0);

            require(gem.transferFrom(msg.sender, address(this), val));
            vat.slip(ilk, urn, int256(wad));

            total = add(total, wad);
            stake[urn] = add(stake[urn], wad);
        }
        crops[urn] = rmulup(stake[urn], share);
        emit Join(urn, usr, val);
    }

    function exit(address urn, address usr, uint256 val) public auth virtual {
        harvest(urn, usr);
        if (val > 0) {
            uint256 wad = wdivup(mul(val, to18ConversionFactor), nps());

            // Overflow check for int256(wad) cast below
            // Also enforces a non-zero wad
            require(int256(wad) > 0);

            require(gem.transfer(usr, val));
            vat.slip(ilk, urn, -int256(wad));

            total = sub(total, wad);
            stake[urn] = sub(stake[urn], wad);
        }
        crops[urn] = rmulup(stake[urn], share);
        emit Exit(urn, usr, val);
    }

    function flee(address urn, address usr, uint256 val) public auth virtual {
        uint256 wad = wdivup(mul(val, to18ConversionFactor), nps());

        // Overflow check for int256(wad) cast below
        // Also enforces a non-zero wad
        require(int256(wad) > 0);

        require(gem.transfer(usr, val));
        vat.slip(ilk, urn, -int256(wad));

        total = sub(total, wad);
        stake[urn] = sub(stake[urn], wad);
        crops[urn] = rmulup(stake[urn], share);

        emit Flee(urn, usr, val);
    }

    function tack(address src, address dst, uint256 wad) public {
        uint256 ss = stake[src];
        stake[src] = sub(ss, wad);
        stake[dst] = add(stake[dst], wad);

        uint256 cs     = crops[src];
        uint256 dcrops = mul(cs, wad) / ss;

        // safe since dcrops <= crops[src]
        crops[src] = cs - dcrops;
        crops[dst] = add(crops[dst], dcrops);

        (uint256 ink,) = vat.urns(ilk, src);
        require(stake[src] >= add(vat.gem(ilk, src), ink));
        (ink,) = vat.urns(ilk, dst);
        require(stake[dst] <= add(vat.gem(ilk, dst), ink));

        emit Tack(src, dst, wad);
    }

    function cage() public auth virtual {
        live = 0;
    }
}

////// src/SynthetixJoin.sol
// Copyright (C) 2021 Dai Foundation
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/* pragma solidity 0.6.12; */

/* //import "./CropJoin.sol"; */

interface StakingRewardsLike_1 {
    function rewardsToken() external view returns (address);
    function stakingToken() external view returns (address);
    function stake(uint256) external;
    function withdraw(uint256) external;
    function getReward() external;
}

// Join adapter for the Synthetix Staking Rewards contract (used by Uniswap V2, LIDO, etc)
contract SynthetixJoinImp is CropJoinImp {

    StakingRewardsLike_1 immutable public pool;

    /**
        @param vat_                 MCD_VAT DSS core accounting module
        @param ilk_                 Collateral type
        @param gem_                 The collateral LP token address
        @param bonus_               The rewards token contract address.
        @param pool_                The staking rewards pool.
    */
    constructor(
        address vat_,
        bytes32 ilk_,
        address gem_,
        address bonus_,
        address pool_
    )
        public
        CropJoinImp(vat_, ilk_, gem_, bonus_)
    {
        // Sanity checks
        require(StakingRewardsLike_1(pool_).rewardsToken() == bonus_, "SynthetixJoin/bonus-mismatch");
        require(StakingRewardsLike_1(pool_).stakingToken() == gem_, "SynthetixJoin/gem-mismatch");

        pool = StakingRewardsLike_1(pool_);
    }

    function init() external {
        gem.approve(address(pool), type(uint256).max);
    }

    function nav() public override view returns (uint256) {
        return total;
    }

    function crop() internal override returns (uint256) {
        if (live == 1) {
            pool.getReward();
        }
        return super.crop();
    }

    function join(address urn, address usr, uint256 val) public override {
        super.join(urn, usr, val);
        if (val > 0) pool.stake(val);
    }

    function exit(address urn, address usr, uint256 val) public override {
        if (live == 1) {
            if (val > 0) pool.withdraw(val);
        }
        super.exit(urn, usr, val);
    }

    function flee(address urn, address usr, uint256 val) public override {
        if (live == 1) {
            if (val > 0) pool.withdraw(val);
        }
        super.flee(urn, usr, val);
    }
    function cage() override public auth {
        require(live == 1, "SynthetixJoin/not-live");

        if (total > 0) pool.withdraw(total);
        live = 0;
    }
    function uncage() external auth {
        require(live == 0, "SynthetixJoin/live");

        if (total > 0) pool.stake(total);
        live = 1;
    }
}