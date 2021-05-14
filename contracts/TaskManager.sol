pragma solidity 0.5.4;

contract TaskManager {

    // Declara inteiro de numero de Tasks
    uint public nTasks;
    
    //enum Mostra em que estado está a Task
    enum TaskPhase {ToDo, InProgress, Done, Blocked, Review, Postponed, Canceled}
    
    //struct Mostra a identificação da Task
    struct TaskStruct {
        address owner;
        string name;
        TaskPhase phase;
        uint priority;
    }

    // Declara Array de Tasks
    TaskStruct[] private tasks;
    
    mapping (address => uint[]) private myTasks;

    event TaskAdded(address owner, string name, TaskPhase phase, uint priority);
    
    // Tasks apenas para o dono
    modifier onlyOwner (uint _taskIndex) {
        // Se o dono é igual quem está enviado a transação
         if  (tasks[_taskIndex].owner == msg.sender) {
           _;
        }
    }
    
    // Inicia Tasks
    constructor() public {
        nTasks = 0;      
        addTask ("Create Task Manager", TaskPhase.Done, 1);
        addTask ("Create Your first task", TaskPhase.ToDo, 5);
    }    

    // Retorna os dados da struct
    function getTask(uint _taskIndex) public view
        returns (address owner, string memory name, TaskPhase phase, uint priority) {
        
        owner = tasks[_taskIndex].owner;
        name = tasks[_taskIndex].name;
        phase = tasks[_taskIndex].phase;
        priority = tasks[_taskIndex].priority;
    }
    
    // Retorna as Tasks, em memória porque não fica gravado no contrato
    function listMyTasks() public view returns (uint[] memory) {
        return myTasks[msg.sender];
    }
    
    // Adiciona uma Task no Blockchain
    function addTask(string memory _name, TaskPhase _phase, uint _priority) public returns (uint index) {
        // require Tratamento de erro
        require ((_priority >= 1 && _priority <=5), "priority must be between 1 and 5");
        TaskStruct memory taskAux = TaskStruct ({
            owner: msg.sender,
            name: _name,
            phase: _phase, 
            priority: _priority
        });
        index = tasks.push (taskAux) - 1;
        nTasks ++;
        myTasks[msg.sender].push(index);
        emit TaskAdded (msg.sender, _name, _phase, _priority);
    }
    
    function updatePhase(uint _taskIndex, TaskPhase _phase) public onlyOwner(_taskIndex) {
        tasks[_taskIndex].phase = _phase;
    }
    
}