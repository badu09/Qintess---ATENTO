/**  Copyright (c) 2008, Matthew Friend, Sales Engineering, Salesforce.com Inc.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
*  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
*  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*  Neither the name of the salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
*  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
*  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
*  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
* To adapt this to anouther Object simply search for "Change" to go to the places 
* where the sObject and query must be changed
*/
public with sharing class AccountStructure{

    //Declare variables
    public String currentId;
    public List<ObjectStructureMap> asm ;
    public Map<String, ObjectStructureMap> masm;
    public List<Integer> maxLevel;
    
    /**
    * Contructor
    */
    public AccountStructure() {
    	this.asm = new List<ObjectStructureMap>{};
    	this.masm = new Map<String, ObjectStructureMap>{};
    	this.maxLevel = new List<Integer>{};
    }
    
    /**
    * Allow page to set the current ID
    */
    public void setcurrentId( String cid ){
        currentId = cid;
    }

    /**
    * Return ObjectStructureMap to page
    * @return asm
    */
    public List<ObjectStructureMap> getObjectStructure(){
        asm.clear();
        if ( currentId == null ) {
            currentId = System.currentPageReference().getParameters().get( 'id' );
        }
        
        System.assertNotEquals( currentId, null, 'sObject ID must be provided' );
        asm = formatObjectStructure( CurrentId );
        
        system.debug('asm: ' + json.serialize(asm));
        
        return asm;
    }

    /**
    * Query Account from top down to build the ObjectStructureMap
    * @param currentId
    * @return asm
    */
    public ObjectStructureMap[] formatObjectStructure( String currentId ){
    
        List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
        masm.clear();

        //Change below
        List<Account> al            = new List<Account>{};
        List<Opportunity> ol        = new List<Opportunity>{};
        List<ID> currentParent      = new List<ID>{};
        Map<ID, String> nodeList    = new Map<ID, String>{};
        List<String> nodeSortList   = new List<String>{};
        List<Boolean> levelFlag     = new List<Boolean>{};
        List<Boolean> closeFlag     = new List<Boolean>{};
        String nodeId               = '0';
        String nodeType             = 'child';
        Integer count               = 0;
        Integer level               = 0;
        Boolean endOfStructure      = false;
        
        //Find highest level obejct in the structure
        currentParent.add( GetTopElement( currentId ) );

        //Loop though all children
        while ( !endOfStructure ){

			al            = new List<Account>{};
			ol        = new List<Opportunity>{};
			
            if( level == 0 ){
                //Change below     
                al = [ SELECT a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id FROM Account a WHERE a.id IN : CurrentParent ORDER BY a.Name ];
            } 
            //else  if( level == 1 ){
                //Change below      
            //    al = [ SELECT a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id FROM Account a WHERE a.ParentID IN : CurrentParent ORDER BY a.Name ];
           //}
            else {
                al = [ SELECT a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id FROM Account a WHERE a.ParentID IN : CurrentParent ORDER BY a.Name ];      
                
                if(al.isEmpty()) {
                	ol = [ SELECT o.AccountId, o.OwnerId, o.Name FROM Opportunity o WHERE o.AccountId IN : CurrentParent ORDER BY o.Name ];
                }
            }

            if( al.size() == 0 && ol.size() == 0){
                endOfStructure = true;
            }
            else{
                currentParent.clear();
                for ( Integer i = 0 ; i < al.size(); i++ ){
                    //Change below
                    Account a = al[i];
                    nodeId = ( level > 0 ) ? NodeList.get( a.ParentId )+'.'+String.valueOf( i ) : String.valueOf( i );
                    masm.put( NodeID, new ObjectStructureMap( nodeID, levelFlag, closeFlag, nodeType, false, false, a ) );
                    currentParent.add( a.id );
                    nodeList.put( a.id,nodeId );
                    nodeSortList.add( nodeId );
                }
                
                for ( Integer i = 0 ; i < ol.size(); i++ ){
                    //Change below
                    Opportunity o = ol[i];
                    nodeId = ( level > 0 ) ? NodeList.get( o.AccountId)+'.'+String.valueOf( i ) : String.valueOf( i );
                    masm.put( NodeID, new ObjectStructureMap( nodeID, levelFlag, closeFlag, nodeType, false, false, o ) );
                    currentParent.add( o.id );
                    nodeList.put( o.id,nodeId );
                    nodeSortList.add( nodeId );
                }
                
                maxLevel.add( level );                
                level++;
            }
        }
        
        //Account structure must now be formatted
        NodeSortList.sort();
        for( Integer i = 0; i < NodeSortList.size(); i++ ){
            List<String> pnl = new List<String> {};
            List<String> cnl = new List<String> {};
            List<String> nnl = new List<String> {};
            
            if ( i > 0 ){
                String pn 	= NodeSortList[i-1];
                pnl 		= pn.split( '\\.', -1 );
            }

            String cn 	= NodeSortList[i];
            cnl 		= cn.split( '\\.', -1 );

            if( i < NodeSortList.size()-1 ){
                String nn = NodeSortList[i+1];
                nnl = nn.split( '\\.', -1 );
            }
            
            ObjectStructureMap tasm = masm.get( cn );
            if ( cnl.size() < nnl.size() ){
                //Parent
                tasm.nodeType = ( isLastNode( cnl ) ) ? 'parent_end' : 'parent';
            }
            else if( cnl.size() > nnl.size() ){
                tasm.nodeType 	= 'child_end';
                tasm.closeFlag 	= setcloseFlag( cnl, nnl, tasm.nodeType );
            }
            else{
                tasm.nodeType = 'child';
            }
            
            tasm.levelFlag = setlevelFlag( cnl, tasm.nodeType ); 
            
            //Change below
            if ( tasm.account.id == currentId ) {
                tasm.currentNode = true;
            }
            asm.add( tasm );
        }
        
        asm[0].nodeType 			= 'start';
        asm[asm.size()-1].nodeType 	= 'end';
        
        return asm;
    }
    
    /**
    * Determin parent elements relationship to current element
    * @return flagList
    */
    public List<Boolean> setlevelFlag( List<String> nodeElements, String nodeType ){
    	
        List<Boolean> flagList = new List<Boolean>{};
        String searchNode 	= '';
        String workNode 	= '';
        Integer cn 			= 0;
        
        for( Integer i = 0; i < nodeElements.size() - 1; i++ ){
            cn = Integer.valueOf( nodeElements[i] );
            cn++;
            searchNode 	= workNode + String.valueOf( cn );
            workNode 	= workNode + nodeElements[i] + '.';
            if ( masm.containsKey( searchNode ) ){
                flagList.add( true );
            }
            else {
                flagList.add( false );
            }
        }
        
        return flagList;
    }
    
    /**
    * Determin if the element is a closing element
    * @return flagList
    */
    public List<Boolean> setcloseFlag( List<String> cnl, List<String> nnl, String nodeType ){
    	
        List<Boolean> flagList = new List<Boolean>{};
        String searchNode 	= '';
        String workNode 	= '';
        Integer cn 			= 0;
        
        for( Integer i = nnl.size(); i < cnl.size(); i++ ){
        	flagList.add( true );
        }
        
        return flagList;
    }
    
    /**
    * Determin if Element is the bottom node  
    * @return Boolean
    */
    public Boolean isLastNode( List<String> nodeElements ){
    	
        String searchNode 	= '';
        Integer cn 			= 0;
        
        for( Integer i = 0; i < nodeElements.size(); i++ ){
            if ( i == nodeElements.size()-1 ){
                cn = Integer.valueOf( nodeElements[i] );
                cn++;
                searchNode = searchNode + String.valueOf( cn );
            }
            else {
                searchNode = searchNode + nodeElements[i] + '.';
            }
        }
        if ( masm.containsKey( searchNode ) ){
            return false;
        }
        else{
            return true;
        }
    }
    
    /**
    * Find the tom most element in Heirarchy  
    * @return objId
    */
    public String GetTopElement( String objId ){
    	
        Boolean top = false;
        while ( !top ) {
            //Change below
            Account a = [ Select a.Id, a.ParentId From Account a where a.Id =: objId limit 1 ];
            
            if ( a.ParentID != null ) {
                objId = a.ParentID;
            }
            else {
                top = true;
            }
        }
        return objId ;
    }
    
	/**
    * Wrapper class
    */
    public with sharing class ObjectStructureMap{

        public String nodeId;
        public Boolean[] levelFlag = new Boolean[]{};
        public Boolean[] closeFlag = new Boolean[]{};
        public String nodeType;
        public Boolean currentNode;
        public Boolean hasOpportunity;
        
        /**
        * @Change this to your sObject
        */
        public Account account;
        public Opportunity opportunity;
        
        public String getnodeId() { return nodeId; }
        public Boolean[] getlevelFlag() { return levelFlag; }
        public Boolean[] getcloseFlag() { return closeFlag; }
        public String getnodeType() { return nodeType; }
        public Boolean getcurrentNode() { return currentNode; }        
        public Boolean gethasOpportunity() { return hasOpportunity; }


        /**
        * @Change this to your sObject
        */
        public Account getaccount() { return account; }
        public Opportunity getopportunity() { return opportunity; }
        
        public void setnodeId( String n ) { this.nodeId = n; }
        public void setlevelFlag( Boolean l ) { this.levelFlag.add(l); }
        public void setlcloseFlag( Boolean l ) { this.closeFlag.add(l); }
        public void setnodeType( String nt ) { this.nodeType = nt; }
        public void setcurrentNode( Boolean cn ) { this.currentNode = cn; }
        public void sethasOpportunity( Boolean ho ) { this.hasOpportunity = ho; }

        /**
        * @Change this to your sObject
        */
        public void setaccount( Account a ) { this.account = a; }
        public void setopportunity( Opportunity o ) { this.opportunity = o; }

        /**
        * @Change the parameters to your sObject
        */
        public ObjectStructureMap( String nodeId, Boolean[] levelFlag,Boolean[] closeFlag , String nodeType, Boolean lastNode, Boolean currentNode, Account a ){
            
            this.nodeId         = nodeId;
            this.levelFlag      = levelFlag; 
            this.closeFlag      = closeFlag;
            this.nodeType       = nodeType;
            this.currentNode    = currentNode;
            this.hasOpportunity    = false;

            //Change this to your sObject  
            this.account = a;
            this.opportunity = new Opportunity();
        }

        public ObjectStructureMap( String nodeId, Boolean[] levelFlag,Boolean[] closeFlag , String nodeType, Boolean lastNode, Boolean currentNode, Opportunity o ){
            
            this.nodeId         = nodeId;
            this.levelFlag      = levelFlag; 
            this.closeFlag      = closeFlag;
            this.nodeType       = nodeType;
            this.currentNode    = currentNode;
			this.hasOpportunity    = true;
			
            //Change this to your sObject  
            this.opportunity = o;
            this.account = new Account();
        }
		
    }
}