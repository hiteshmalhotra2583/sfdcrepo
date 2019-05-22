({
    
    getClassStatus:function(component,event,state,policyid,statepolicymap){
        var retClass = 'blank';
        var isdefined = false;
        if((statepolicymap[state]!=undefined)){
            isdefined = (statepolicymap[state][policyid])!=undefined;
        }
        if(isdefined){
            if(statepolicymap[state][policyid].Status != undefined){
                retClass = statepolicymap[state][policyid].Status.toLowerCase().replace(/ /g,'');
            }
        }
        component.set("v.imgName",retClass);
    },
    getStatusMessage: function(component,event,state,policyid,statepolicymap){
        var ret = '';
        var isdefined = false;
        
        if((statepolicymap[state]!=undefined)){
            isdefined = (statepolicymap[state][policyid]!=undefined);
        }
        if(isdefined){
            if(statepolicymap[state][policyid].Status != undefined){
                ret = statepolicymap[state][policyid].Status;
                if(statepolicymap[state][policyid].StatusDate != null){
                    ret += ' - ' + statepolicymap[state][policyid].StatusDate;
                }
            }else{
                ret = 'Not Set';
            }
        }else{
            ret = 'Not Set';
        }
       component.set('v.statusMsg',ret);
    },
})