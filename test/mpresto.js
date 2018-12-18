const MPresto = artifacts.require('./MPresto.sol')

contract("MPresto", accounts => {
  var contract = null;
  const setInstance = (v) => contract = v;

  it("create a item", () => MPresto.deployed().then(setInstance)
    .then(() => contract.createItem('item1', 1))
    .then(() => contract.getItem(0))
    .then(item => {
      assert.equal('item1', item[0])
      assert.equal(1, item[1])
    })
  )
})
