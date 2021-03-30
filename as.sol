pragma experimental ABIEncoderV2;

contract Owned {
    address payable private owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier Onlyowner{
        require(
            msg.sender == owner, 
            'lya ti krisa'
            );
        _;
    }
    
    function ChangeOwner(address newOwner) public Onlyowner {
        owner = payable(newOwner);
    }
    
    function GetOwner() public returns (address){
        return owner;
    }
}

contract ROSReestr is Owned
{
    uint256 private price = 100 wei;
    
    enum RequestType{NewHome, EditHome}
    //enum Position{}
    
    struct Ownership
    {
        string homeAddress;
        address owner;
        uint p;
    }   
    
    struct Owner{
        string name;
        uint passSer;
        uint passNum;
        uint256 date;
        string phoneNumber;
    }
    
    struct Home
    {
        string homeAddress;
        uint area;
        uint cost;
    }
    
    struct Request
    {
        RequestType requestType;
        Home home; 
        bool isProcessed;
        uint result;
        address adr;
    }
    
    struct Employee
    {
        string nameEmployee;
        string position;
        string phoneNumber;
        bool isset;
    }
    
    mapping(address => Employee) private employees;
    mapping(address => Owner) private owners;
    mapping(address => Request) private requests;
    address[] requestsInitiator;
    mapping(string => Home) private homes;
    mapping(string => Ownership[]) private ownerships;
    
    uint private amount;

    
    modifier OnlyEmployee {
        require(
            employees[msg.sender].isset != false,
            'lya ti krisa'
            );
        _;
    }
    
    modifier Costs(uint value){
        require(
            msg.value >= value,
            'Not enough funds!!'
            );
        _;
    }
    
    
    function AddHome(string memory _adr, uint _area, uint _cost) public {
        Home memory h;
        h.homeAddress = _adr;
        h.area = _area;
        h.cost = _cost;
        homes[_adr] = h;
    }
    
    function GetHome(string memory adr) public returns (uint _area, uint _cost) {
        return (homes[adr].area, homes[adr].cost);
    }
    
    function AddEmployee(address empl, string memory _name, string memory _position, string memory _phoneNumber) public Onlyowner {
        Employee memory e;
        e.nameEmployee = _name;
        e.position = _position;
        e.phoneNumber = _phoneNumber;
        employees[empl] = e;
        e.isset = true;
    }
    
    function GetEmployee(address empl) public Onlyowner returns (string memory nameEmployee, string memory _position, string memory _phoneNumber) {
        return (employees[empl].nameEmployee, employees[empl].position, employees[empl].phoneNumber);
    }
    
    function EditEmployee(address empl, string memory _newname, string memory _newposition, string memory _newphoneNumber) public Onlyowner {
        employees[empl].nameEmployee = _newname;
        employees[empl].position = _newposition;
        employees[empl].phoneNumber = _newphoneNumber;
    }
    
    function DeleteEmployee(address empl) public Onlyowner returns (bool) {
        if(employees[msg.sender].isset == true){
            delete employees[empl];
            return true;
        }
        return false;
    }
    
    function AddRequest(uint _reqType, string memory _homeAddress, uint _area, uint _cost, address _newOwner) public payable Costs(price) returns(bool)
    {
        Home memory h;
        h.homeAddress = _homeAddress;
        h.area = _area;
        h.cost = _cost;
        Request memory r;
        r.requestType = _reqType == 0? RequestType.NewHome : RequestType.EditHome;
        r.home = h;
        r.result = 0;
        r.adr = _reqType == 0 ? address(0) : _newOwner;
        r.isProcessed = false;
        requests[msg.sender] = r;
        requestsInitiator.push(msg.sender);
        amount += msg.value;
        return true;
    }
    
    function GetRequest() public OnlyEmployee view returns (uint[] memory, uint[] memory, string[] memory)
    {
        uint[] memory ids = new uint[](requestsInitiator.length);
        uint[] memory types = new uint[](requestsInitiator.length);
        string[] memory homeAddress = new string[](requestsInitiator.length);
        for(uint i = 0; i != requestsInitiator.length; i++)
        {
            ids[i] = i;
            types[i] = requests[requestsInitiator[i]].requestType == RequestType.NewHome ? 0 : 1;
            homeAddress[i] = requests[requestsInitiator[i]].home.homeAddress;
        }
        return (ids, types, homeAddress);
    }
    
    function NewCost(uint256 newCost) public Onlyowner
    {
        price = newCost;
    }
    
    function GetCost() public returns (uint nowcost){
        return price;
    }
}
