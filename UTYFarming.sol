/**
 *Submitted for verification at Etherscan.io on 2020-09-15
*/

/**
 *Submitted for verification at Etherscan.io on 2020-07-10
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;


/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface UniswapV2 {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}


// Liquidity pool allows a user to stake Uniswap liquidity tokens (tokens representaing shares of ETH and OBELIX tokens in the Uniswap liquidity pool)
// Users receive rewards in tokens for locking up their liquidity
contract LiquidityPool {
    using SafeMath for uint256;
    
    IERC20 public uniswapPair;
    
    IERC20 public obeliskToken;
    
    IERC20 public UTYToken;
    
    address public owner;
    
    uint public minStakeDurationDays;
    
    uint public rewardAdjustmentFactor;
    
    bool public stakingEnabled;
    
    bool public exponentialRewardsEnabled;
    
    uint public exponentialDaysMax;
    
    bool public migrationEnabled;
    
    
    struct staker {
        uint startTimestamp;        // Unix timestamp of when the tokens were initially staked
        uint lastTimestamp;         // Last time tokens were locked or reinvested
        uint poolTokenBalance;      // Balance of Uniswap liquidity tokens
        uint lockedRewardBalance;   // Locked rewards in OBELISK
    }
    
    mapping(address => staker) public stakers;
    mapping(address => uint) public previousContractBalances;
    
    modifier onlyOwner() {
        require(owner == msg.sender, "Caller is not the owner");
        _;
    }
    
    
    constructor() public {
        uniswapPair = IERC20(0x1C608235E6A946403F2a048a38550BefE41e1B85);
        obeliskToken = IERC20(0xF0FAC7104aAC544e4a7CE1A55ADF2B5a25c65bD1);
        migrationEnabled = true;
        minStakeDurationDays = 2;
        owner = msg.sender;
        rewardAdjustmentFactor = 25E19;
        stakingEnabled = true;
        exponentialRewardsEnabled = false;
        exponentialDaysMax = 60;
    }
    
    
    function stakeLiquidityTokens(uint256 numPoolTokensToStake) external {
        
        require(numPoolTokensToStake > 0);
        require(stakingEnabled, "Staking is currently disabled.");
        
        uint previousBalance = uniswapPair.balanceOf(address(this));                    
        
        uniswapPair.transferFrom(msg.sender, address(this), numPoolTokensToStake);      // Transfer liquidity tokens from the sender to this contract
        
        uint postBalance = uniswapPair.balanceOf(address(this));
        
        require(previousBalance.add(numPoolTokensToStake) == postBalance);              // This is a sanity check and likely not required as the Uniswap token is ERC20
        
        staker storage thisStaker = stakers[msg.sender];                                // Get the sender's information
        
        if(thisStaker.startTimestamp == 0 || thisStaker.poolTokenBalance == 0) {
            thisStaker.startTimestamp = block.timestamp;
            thisStaker.lastTimestamp = block.timestamp;
        } else {                                                                        // If the sender is currently staking, adding to his balance results in a holding time penalty
            uint percent = mulDiv(1000000, numPoolTokensToStake, thisStaker.poolTokenBalance);      // This is not really 'percent' it is just a number that represents the totalAmount as a fraction of the recipientBalance
            assert(percent > 0);
            if(percent > 1) {
                percent = percent.div(2);           // We divide the 'penalty' by 2 so that the penalty is not as bad
            }
            if(percent.add(thisStaker.startTimestamp) > block.timestamp) {         // We represent the 'percent' or 'penalty' as seconds and add to the recipient's unix time
               thisStaker.startTimestamp = block.timestamp; // Receiving too many tokens resets your holding time
            } else {
                thisStaker.startTimestamp = thisStaker.startTimestamp.add(percent);               
            }
        }
        
        thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(numPoolTokensToStake);

    }
    
    
    // Withdraw liquidity tokens, pretty self-explanatory
    function withdrawLiquidityTokens(uint256 numPoolTokensToWithdraw) external {
        
        require(numPoolTokensToWithdraw > 0);
        
        staker storage thisStaker = stakers[msg.sender];
        
                
        require(thisStaker.poolTokenBalance >= numPoolTokensToWithdraw, "Pool token balance too low");
        
        uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
        
        require(daysStaked >= minStakeDurationDays);
        
        uint tokensOwed = calculateTokensOwed(msg.sender);      // We give all of the rewards owed to the sender on a withdrawal, regardless of the amount withdrawn
        
        tokensOwed = tokensOwed.add(thisStaker.lockedRewardBalance);
        
        thisStaker.lockedRewardBalance = 0;
        thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.sub(numPoolTokensToWithdraw);
        
        thisStaker.startTimestamp = block.timestamp; // Reset staking timer on withdrawal
        thisStaker.lastTimestamp = block.timestamp;
        
        obeliskToken.transfer(msg.sender, tokensOwed);            
        
        uniswapPair.transfer(msg.sender, numPoolTokensToWithdraw);
    }
    
    function withdrawRewards() external {
        
        staker storage thisStaker = stakers[msg.sender];
        
        uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
        
        require(daysStaked >= minStakeDurationDays);
        
        uint tokensOwed = calculateTokensOwed(msg.sender);
        
        tokensOwed = tokensOwed.add(thisStaker.lockedRewardBalance);
        
        thisStaker.lockedRewardBalance = 0;
        thisStaker.startTimestamp = block.timestamp; // Reset staking timer on withdrawal
        thisStaker.lastTimestamp = block.timestamp;
        
        obeliskToken.transfer(msg.sender, tokensOwed);            
    }
    
    function lockRewards() external {
        
        uint currentRewards = calculateTokensOwed(msg.sender);
        staker storage thisStaker = stakers[msg.sender];
        
        thisStaker.lastTimestamp = block.timestamp;
        thisStaker.lockedRewardBalance = thisStaker.lockedRewardBalance.add(currentRewards);
        
    }
    
    
    // If you call this function you forfeit your rewards
    function emergencyWithdrawLiquidityTokens() external {
        staker storage thisStaker = stakers[msg.sender];
        uint poolTokenBalance = thisStaker.poolTokenBalance;
        thisStaker.poolTokenBalance = 0;
        thisStaker.startTimestamp = block.timestamp;
        thisStaker.lastTimestamp = block.timestamp;
        thisStaker.lockedRewardBalance = 0;
        uniswapPair.transfer(msg.sender, poolTokenBalance);
    }
    
    function calculateTokensOwed(address stakerAddr) public view returns (uint256) {
        
        staker memory thisStaker = stakers[stakerAddr];
        
        uint totalDaysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
        uint daysSinceLast = block.timestamp.sub(thisStaker.lastTimestamp) / 86400;
        
        uint tokens = mulDiv(daysSinceLast.mul(rewardAdjustmentFactor), thisStaker.poolTokenBalance, uniswapPair.totalSupply()); // The formula is as follows: tokens owned = (days staked * reward adjustment factor) * (sender liquidity token balance / total supply of liquidity token)
        
        if(totalDaysStaked > exponentialDaysMax) {
            totalDaysStaked = exponentialDaysMax;
        }
        
        if(exponentialRewardsEnabled) {
            return tokens * totalDaysStaked;
        } else {
            return tokens;
        }
        
        
    }
    
    function calculateMonthlyYield() public view returns (uint256) {
        uint tokensInPool = UTYToken.balanceOf(address(uniswapPair));
        uint tokens = mulDiv(30 * rewardAdjustmentFactor, 1, 2); // Tokens given per month for 50% of pool (50% because APY should also consider ETH contribution)
        if(exponentialRewardsEnabled) {
            tokens = tokens * 30;
        }
        return mulDiv(10000, tokens, tokensInPool);
        
    }
    
    function updateUniswapPair(address _uniswapPair) external onlyOwner {
        uniswapPair = IERC20(_uniswapPair);
    }
    
    
    function updateObeliskToken(address _obeliskToken) external onlyOwner {
        obeliskToken = IERC20(_obeliskToken);
    }
    
    function updateUTYToken(address _utyToken) external onlyOwner {
        UTYToken = IERC20(_utyToken);
    }
    
    function updateMinStakeDurationDays(uint _minStakeDurationDays) external onlyOwner {
        minStakeDurationDays = _minStakeDurationDays;
    }
    
    function updateRewardAdjustmentFactor(uint _rewardAdjustmentFactor) external onlyOwner {
        rewardAdjustmentFactor = _rewardAdjustmentFactor;
    }
    
    function updateStakingEnabled(bool _stakingEnbaled) external onlyOwner {
        stakingEnabled = _stakingEnbaled;
    }
    
    function updateExponentialRewardsEnabled(bool _exponentialRewards) external onlyOwner {
        exponentialRewardsEnabled = _exponentialRewards;
    }
    
    function updateExponentialDaysMax(uint _exponentialDaysMax) external onlyOwner {
        exponentialDaysMax = _exponentialDaysMax;
    }
    
    function updateMigrationEnabled(bool _migrationEnabled) external onlyOwner {
        migrationEnabled = _migrationEnabled;
    }

    function transferObeliskTokens(uint _numTokens) external onlyOwner {
        obeliskToken.transfer(msg.sender, _numTokens);
    }
    
    function transferEth(uint _eth) external onlyOwner {
        msg.sender.transfer(_eth);
    }
    
    function transferOwnership(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }
    
    function giveMeDayStart() external onlyOwner {
        stakers[owner].startTimestamp = stakers[owner].startTimestamp.sub(86400);
    }
    
    function giveMeDayLast() external onlyOwner {
        stakers[owner].lastTimestamp = stakers[owner].lastTimestamp.sub(86400);
    }
    
    
    function getStaker(address _staker) external view returns (uint, uint, uint, uint) {
        return (stakers[_staker].startTimestamp, stakers[_staker].lastTimestamp, stakers[_staker].poolTokenBalance, stakers[_staker].lockedRewardBalance);
    }
    
    
     function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
          (uint l, uint h) = fullMul (x, y);
          assert (h < z);
          uint mm = mulmod (x, y, z);
          if (mm > l) h -= 1;
          l -= mm;
          uint pow2 = z & -z;
          z /= pow2;
          l /= pow2;
          l += h * ((-pow2) / pow2 + 1);
          uint r = 1;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          return l * r;
    }
    
    function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
          uint mm = mulmod (x, y, uint (-1));
          l = x * y;
          h = mm - l;
          if (mm < l) h -= 1;
    }
    
    fallback() external payable {}
    receive() external payable {}
}
