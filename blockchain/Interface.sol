// // SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

 import "./Election.sol";
 import "./Candidate.sol";
 import "./Voter.sol";
contract Interface {

    Voter[] public voters;

     function addVoter() public returns (address) {
        for (uint256 i = 0; i < voters.length; i++) {
            if (voters[i].getOwner() == msg.sender) {
             revert("voter already registered");
            }
}  
   

        Voter v= new Voter(msg.sender);
        voters.push(v);
        return  address(v);
        
     }
     function  addElection() public returns (address){
        Election e= new Election();
        return address(e);

     }
    

     function addCandidate(address election) public returns (address) {
        Candidate c= new Candidate(election);
        Election e = Election(election);
        e.addCandidate(c);
        return address(c);
     }

     function  vote(address election,address candidate, address voter ) public isValidUser  /*candidateExists(candidate,election) hasVoted(election)*/ returns (bool) {
       Voter v= Voter(voter);
       v.voteDone(election);
       v.setCandidateVote(candidate, election);
       Election e= Election(election);
       e.setVote(candidate);
      return true;

   
     }
     function getResult(address election ) public view returns (address candidate , uint votes) {
         Election e= Election(election);
           (candidate,votes)=e.getMaxVote();

           return (candidate,votes);



     }

     modifier  isValidUser(){
      bool found= false;
      for(uint256 i=0 ;i< voters.length;i++){
        if (address(voters[i].getOwner())== msg.sender){
         found= true;
        }
      }
      if (!found){
         revert("voter has not been registered "); 
      }
      _;
     }


     modifier candidateExists(address election , address candidate ){
      Election e= Election(election);
      Candidate c= Candidate(candidate);
      bool found= false;
      for ( uint256 i=0 ;i< e.getLength();i++){
         if (e.getAddress(i)==candidate){
            found= true;
            break;

         }   
      }
      if (!found){
            revert("your candidate has not registered for given election");
         }
   _;

      
     }
     modifier hasVoted(address election) {
      Voter v = Voter(msg.sender);
      require(!v.getVoteDetail(election),"voter has already voted in the given election");
      //m default value for bool would be false for all addresses 


      _;
     }
    


    




}
