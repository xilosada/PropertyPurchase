pragma solidity ^0.4.14;
contract PropertyPurchase {

    Property property;
    address agent;
    address hq;
    uint price;
    uint ownerGains;
    uint agentCommission;
    uint headQuartersComission;

    struct Property {
        string documentId;
        address owner;
        bool transferred;
    }

    function PropertyPurchase(string documentId, address owner, address _agent) {
        property = Property(documentId, owner, false);
        agent = _agent;
        hq = msg.sender;
    }

    function setDocumentationReceivedAndSigned(uint _ownerGains, uint _agentCommission, uint _headQuartersComission) {
        require (msg.sender == hq);
        require(property.transferred == false);
        ownerGains = _ownerGains;
        agentCommission = _agentCommission;
        headQuartersComission = _headQuartersComission;
        price = ownerGains + agentCommission + headQuartersComission;
        property.transferred = true;
    }

    function depositFounds() payable
            returns(address) {
        require (property.transferred);
        require (msg.value >= price);
        agent.transfer(agentCommission);
        property.owner.transfer(ownerGains);
        hq.transfer(headQuartersComission);
        msg.sender.transfer(msg.value - price);
        property.owner = msg.sender;
        return property.owner;
    }

    function getPrice()
            constant returns(uint) {
        return price;
    }

    function getPropertyDocumentation()
            constant returns(string) {
        return property.documentId;
    }

    function getPropertyOwner()
            constant returns(address) {
        return property.owner;
    }

    function getHqAddress()
            constant returns(address) {
        return hq;
    }

    function getAgentAddress()
            constant returns(address) {
        return agent;
    }
}
