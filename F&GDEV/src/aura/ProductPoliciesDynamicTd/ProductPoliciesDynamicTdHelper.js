({
    getProdStateStatus:function(component, event,prodid, state, policyid) {
        var hasRelation =  component.get('v.hasRelation');
        var prodstatepolicystatestatmap = component.get('v.prodstatepolicystatestatmap');
        var isdefined = false;
        if(prodstatepolicystatestatmap[prodid]!=undefined){
            if(prodstatepolicystatestatmap[prodid][state]!=undefined){
                var stateavailid = Object.keys(prodstatepolicystatestatmap[prodid][state])[0];
                if(stateavailid!='' && !stateavailid.includes('StateAvailId')){
                    isdefined = (prodstatepolicystatestatmap[prodid][state][stateavailid].PolicytoProdStateStat[policyid]);
                }
            }
        }
        
        if(isdefined){
            var stateavailid = Object.keys(prodstatepolicystatestatmap[prodid][state])[0];
            var prodstatestat = prodstatepolicystatestatmap[prodid][state][stateavailid].PolicytoProdStateStat[policyid];
            hasRelation = ((prodstatestat.ProductStateStatusId == null && prodstatestat.InsertOrDelete) || 
                           (prodstatestat.ProductStateStatusId != null && !prodstatestat.InsertOrDelete));
        }
        component.set('v.hasRelation',hasRelation);
    },
    getStatusMessage: function(component,event,prodid,state,policyid,prodstatepolicystatestatmap){
        let statepolicymap = component.get('v.statepolicymap');
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
    /*
     getStatusMessage: function(component,event,prodid,state,policyid,prodstatepolicystatestatmap){
        var ret = '';
        var isdefined = false;
        if(prodstatepolicystatestatmap[prodid]!=undefined){
            if(prodstatepolicystatestatmap[prodid][state]!=undefined){
                var stateavailid = Object.keys(prodstatepolicystatestatmap[prodid][state])[0];
                if(stateavailid!='' && !stateavailid.includes('StateAvailId')){
                    isdefined = (prodstatepolicystatestatmap[prodid][state][stateavailid]!=undefined);
                }
            }
        }
        if(isdefined){
            if(prodstatepolicystatestatmap[prodid][state][stateavailid].Status != undefined){
                ret = prodstatepolicystatestatmap[prodid][state][stateavailid].Status;
                if(prodstatepolicystatestatmap[prodid][state][stateavailid].StatusDate != null){
                    ret += ' - ' + prodstatepolicystatestatmap[prodid][state][stateavailid].StatusDate;
                }
            }else{
                ret = 'Not Set';
            }
        }else{
            ret = 'Not Set';
        }
       component.set('v.statusMsg',ret);
    },*/
})