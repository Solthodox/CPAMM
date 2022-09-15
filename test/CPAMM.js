const {ethers} = require("hardhat")
const {expect} = require("chai")

const toEther = (n) => {
  return ethers.utils.parseUnits(n.toString() , "ether")

}

describe("CPAMM" , ()=>{
  let token0,token1
  let swap
  let deployer

  beforeEach(async()=>{
    const accounts = await ethers.getSigners()
    deployer = accounts[0]

    const Token0 = await ethers.getContractFactory("token0")
    const Token1 = await ethers.getContractFactory("token1")

    token0 = await Token0.deploy()
    token1 = await Token1.deploy()

    const CPAMM = await ethers.getContractFactory("CPAMM")
    swap = await CPAMM.deploy(token0.address , token1.address)

    const approval0 = await token0.approve(swap.address , toEther(50000))
    await approval0.wait()
    const approval1 = await token1.approve(swap.address , toEther(50000))
    await approval1.wait()
    
  })

  describe("Deposit" , ()=>{
    it("Should deposit correctly" , async()=>{
      await expect(swap.addLiquidity(toEther(2000) , toEther(3000))).to.changeTokenBalance(token0, swap, toEther(2000));
    })

    it("Should revert if dont add liquidity properly" , async()=>{
      await expect(swap.addLiquidity(toEther(2000) , toEther(2000))).to.be.reverted;
    })

    it("Should get slippage on swap" , async()=>{
      const balanceBefore = await token1.balanceOf(deployer.address)
      const tx = await swap.swap(token0.address , toEther(200))
      await tx.wait()
      const balanceAfter = await token1.balanceOf(deployer.address)
      const amountOut = balanceAfter - balanceBefore
      expect(amountOut).to.be.lessThan(300)
    })

  })





})