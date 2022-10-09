//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract helpSmaKids{
    // Event to emit when a donate reward transferred.
    event TransferReceived(address _from, uint _amount);
    event TransferSent(address _from, address _destAddr, uint _amount);

    // Event to emit when a donate and message is created.
    event donateAndMessage(
        address indexed from,
        uint256 timestamp,
        string name,
        string message,
        uint256 value
    );

    
    // data structs
    struct Data {
        address from;
        uint256 timestamp;
        string name;
        string message;
        uint256 value;
    }
     mapping(uint => mapping(address => uint)) public getDonateByIDandAdress;
    // Address of contract deployer. Marked payable so that
    // we can withdraw to this address later.
    address payable owner;
    //total donation amount
    uint256 totalAmount;

    uint256 public balance;

    // List of all datas 
    Data[] datas;

    

    constructor() {
        // Store the address of the deployer as a payable address.
        // When we withdraw funds, we'll withdraw here.
        owner = payable(msg.sender);
    }
    receive() payable external {
        balance += msg.value;
        emit TransferReceived(msg.sender, msg.value);
    }    
    //only owner modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;}

    /**
     *  fetches all stored datas
     */
    function getData() public view returns (Data[] memory) {
        return datas;
    }
    // fetches total donation amount
    function getTotalDonations() view public returns(uint) {
        return totalAmount;
  }
    /**
     *  _id id of donator
     *  _name name of the donator
     *  _message a nice message from the donator
     */
    function helpSMA(uint256 _id, string memory _name, string memory _message, IERC20 token) public payable {
        //10 wei limit to prevent spam attack by token hunters
        require(msg.value > 10 wei, "please deposit at least 10 wei");
        // Adding the data for the query by ID
        getDonateByIDandAdress[_id][msg.sender] += msg.value;
        //increase total donation amount 
        totalAmount += msg.value;
        // Add the data to storage!
        datas.push(Data(
            msg.sender,
            block.timestamp,
            _name,
            _message,
            msg.value
        ));

        // Emit a donatAndMessage event with details about the data.
        emit donateAndMessage(
            msg.sender,
            block.timestamp,
            _name,
            _message,
            msg.value
        );
        //send reward token.
        uint256 erc20balance = token.balanceOf(address(this));
        require(1000000000000000000 <= erc20balance, "balance is low");
        token.transfer(msg.sender, 1000000000000000000);
        emit TransferSent(msg.sender, msg.sender, 1000000000000000000);
    }

    /**
     * send the entire balance stored in this contract to the owner
     */
    function withdrawDonates() public  onlyOwner(){
        require(owner.send(address(this).balance));
    }
}