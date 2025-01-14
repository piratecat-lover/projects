let humanScore = 0;
let computerScore = 0;
let currentRoundNumber = 1;

// Write your code below:

const generateTarget = () =>{
    return Math.floor(Math.random()*10);
};

const compareGuesses = (hguess, cguess, sguess) => {
    const result=Math.abs(sguess-hguess)<=Math.abs(sguess-cguess)? true : false;
    return result;
};

const updateScore = (winner) =>{
    winner==="human"?humanScore++:computerScore++;
};

function advanceRound(){
    currentRoundNumber++;
};