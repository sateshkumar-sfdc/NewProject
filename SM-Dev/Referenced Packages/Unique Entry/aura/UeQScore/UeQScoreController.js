({
	doInit : function(c, e, h) {
        c.set('v.card', { visible : true, showList : false, message : "Loading available Fields"});
		c.set('v.fields', []);
        c.set('v.protentialScore', '-1');
        h.getRecord(c, h);
	},

    toggleCard : function(c, e, h) {
        var card = c.get('v.card');
        card.visible = !card.visible;
        c.set('v.card', card);
	},

    onScriptLoaded : function(c, e, h) {
		//var temp = sforce.connection.describeSObject('Account');
        //console.log(JSON.stringify(temp))
	},

    onImproveButtonClick : function(c, e, h) {
        h.updateRecord(c, h);
    }
})