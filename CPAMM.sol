// SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;
import "./IERC20.sol";

contract CPAMM {
    address public inmutable token0;
    address public inmutable token1;

    mapping(address => uint256) private _reserves;
    uint public totalSupply;

    mapping(address => uint) private _balances;

    constructor(address _token0 , address _token1){
        token0 = _token0;
        token1 = _token1;
    }

    function swap(address _tokenIn , uint _amountIn) 
        external returns(uint amountOut)
    {
        require(_tokenIn == token0 || _tokenIn == token1, 
        "Invalid token");
        require(_amountIn>0, "Amount is 0");
        //pull token in
        bool tokenIs0 = _tokenIn==token0 ? ;
        (address tokenIn , address tokenOut , 
        uint reserveIn , uint reserveOut) = tokenIs0 
            ? (token0, token1 ,_reserves[token0] , _reserves[token1]) 
            : (token1 , token0 , _reserves[token1] , _reserves[token0]);
        IERC20(tokenIn).transferFrom(msg.sender, address(this) , _amountIn);
        // Calculate token out => 0.3% fee
        // ydx / (x + dx) = dy
        uint amountInWithFee = _amountIn  * 977 / 1000; 
        uint amountOut = (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee);
        // Transfer token out
        IERC20(tokenOut).transfer(msg.sender , amountOut);
        //update reserves 
        _update(
            IERC20(token0).balanceOf(address(this)),
            IERC20(token1).balanceOf(address(this))
        )
    }

    function addLiquidity(uint _amount0 , uint _amount1) 
        external returns(uint shares)
    {   
        // Pull in token0 and token1
        IERC20(token0).transferFrom(smg.sender , address(this) , _amount0);
        IERC20(token1).transferFrom(smg.sender , address(this) , _amount1);

        // require (dy / dx = y/x)
        if(_reserves[token0] > 0 || _reserves[token1] > 0) {
            require (_reserves[token0] * _amount1 == _reserves[token1] * _amount0
            "dy / dx != y / x");
        }

        // Mint shares
        // f(x,y) = value of liauidity = sqrt(xy)
        // s = dx / x * T = dy/y * T
        if (totalSupply == 0){
            shares = _sqrt(_amount0 * _amount1);
        }else{
            shares = _min(
                // for security we will pick the less big number of both calculations
                (_amount0 * totalSupply) / _reserves[token0] ,
                (_amount1 * totalSupply) / _reserves[token1]
            );
        }
        require(shares >0  , "Shares = 0");
        // mint the shares
        _mint(msg.sender , shares);
        // update reserves
        _update(
            IERC20(token0).balanceOf(address(this)),
            IERC20(token1).balanceOf(address(this))
        );


    }

    function removeLiquidity(uint _shares) 
        external returns(uint amount0 , uint amount1) 
    {
        // calculate amount 0 and amount 1 to withdraw
        // dx = s / T * x
        // dy = s / T * y
        uint bal0 = IERC20(token0).balanceOf(address(this));
        uint bal1 = IERC20(token1).balanceOf(address(this));

        amount0  = _shares * bal0 / totalSupply;
        amount1  = _shares * bal0 / totalSupply;
        require(amoutn0 > 0 && amount1 >0 ,
         "Amount0 or amount1 = 0");
        // Burn shares
        _burn(msg.sender , _shares);
        // Update reserves
        _update(
            bal0 - amount0,
            bal1 - amount1
        );
        // Trasfer tokens
        IERC20(token0).transfer(msg.sender , amount0);
        IERC20(token1).transfer(msg.sender , amount1);

    }
    function _mint(address _to , uint _amount) private{
        _balances[_to]+=_amount;
        totalSupply+=_amount;
    }
    function _burn(address from , uint _amount) private{
        _balances[_to]-=_amount;
        totalSupply-=_amount;
    }

    function _update(uint _reso0 , uint _res1) private{
        _reserves[token0] = _res0;
        _reserves[token1] = _res1;
    }
    // Square root function
    function _sqrt(uint y) private pure returns (uint z){
        if(y > 3){
            z = y;
            uint x = y/2 +1 ;
            while(x<z) {
                z = x;
                x = (y / x + x) / 2;
            }
        }else if(y != 0){
            z = 1;
        }

    }

    function _min(uintx , uint y) private pure returns(uint){
        return x<= y ? x : y;
    }

}