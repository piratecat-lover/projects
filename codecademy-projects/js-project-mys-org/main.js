// Returns a random DNA base
const returnRandBase = () => {
  const dnaBases = ['A', 'T', 'C', 'G'];
  return dnaBases[Math.floor(Math.random() * 4)];
};

// Returns a random single stand of DNA containing 15 bases
const mockUpStrand = () => {
  const newStrand = [];
  for (let i = 0; i < 15; i++) {
    newStrand.push(returnRandBase());
  }
  return newStrand;
};


const pAequorFactory = (specimenNum, dna) => {
  return {
    specimenNum,
    dna,
    mutate(){
      let i=Math.floor(Math.random()*15);
      let a=this.dna[i];
      const dnaBases = ['A', 'T', 'C', 'G'];
      while(this.dna[i]===a) {
        a = dnaBases[Math.floor(Math.random()*4)];
      }
      this.dna[i]=a;
    },
    compareDNA(pAequor){
      let count = 0;
      for(let i =0;i<pAequor.length;i++) {
        if(this.dna[i] === pAequor[i]) count++;
      }
      console.log(`Specimen #${this.specimenNum} and Specimen #${pAequor.specimenNum} have ${count/pAequor.length*100} DNA in common.`);
    },
    willLikelySurvive(){
      let count = 0;
      for(let i =0;i<this.dna.length;i++){
        if(this.dna[i]==='C' || this.dna[i]==='G') count++;
      };
      return count/this.dna.length*100>=60?true:false;
    },
  }
};

const specimenArray = [];
let num=0;
while(specimenArray.length<30){
  const newStrand = pAequorFactory(num, mockUpStrand());
  if(newStrand.willLikelySurvive()) {specimenArray.push(newStrand);
    num++;
  }
  else continue;
}