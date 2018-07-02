({
	getRecord: function(c, h){
		var action = c.get('c.getRecordById');
		var keyFields = h.getKeyFields();

		action.setParams({ recordId: c.get('v.recordId') });
		action.setCallback(this, function(response) {
			//console.log(response);
			var recordWrapper = JSON.parse(response.getReturnValue());
			if(recordWrapper == null || recordWrapper == {}){
				c.set('v.score', 'Error - Can not get record');
				return;
			}
			
			var fields = [];
			var record = recordWrapper.record;
			var listFieldInfo = recordWrapper.listFieldInfo;
			var allowTypes = ['string','phone','email','url','textarea','picklist'];

			for(var i = 0; i < listFieldInfo.length; i++){
				var fieldInfo = listFieldInfo[i];
				if(record.hasOwnProperty(fieldInfo.fieldName)){
						var importance = 1;
						if(keyFields.indexOf(fieldInfo.fieldName) > -1)
							importance = 2;
						fields.push({ label: fieldInfo.fieldName, value: record[fieldInfo.fieldName], importance: importance});
				}else{
					record[fieldInfo.fieldName] = "";
					var importance = 1;
					if(keyFields.indexOf(fieldInfo.fieldName) > -1)
						importance = 2;
					fields.push({ label: fieldInfo.fieldName, value: "", importance: importance});
				}
			}

			c.set('v.fields', fields);
			c.set('v.record', record);
			h.getScore(c);
			h.proactiveCall(c, h);
		})

		$A.enqueueAction(action);
	},

	proactiveCall: function(c, h){
		var action = c.get('c.callService');
		var record = c.get('v.record');
		var missingFields = c.get('v.missingFields');

		action.setParams({ mapValues: record, isFinalCall: false });
		action.setCallback(this, function(response) {
			console.log('proactiveCall');
			//console.log(response);
			
			var mapResponse ={};
			mapResponse = JSON.parse(response.getReturnValue());
			console.log(mapResponse);
			if(mapResponse == null || mapResponse == {}){
				c.set('v.score', 'Error - Can not check for available Field');
				return;
			}

			for(var i = 0; i < missingFields.length; i ++){
				var key = missingFields[i].label;
				if(!mapResponse.Response.Payload.Values.hasOwnProperty(key) 
					|| mapResponse.Response.Payload.Values[key] == null 
					|| mapResponse.Response.Payload.Values[key] == ""
					|| mapResponse.Response.Payload.Values[key] == false
					|| mapResponse.Response.Payload.Values[key] == "false"){
					console.log("remove " + missingFields[i].label);
					
					missingFields.splice(i, 1);
					i--;
				}else{
					missingFields[i].value = mapResponse.Response.Payload.Values[key];
				}
			}
			c.set('v.missingFields', missingFields);
			var card = c.get('v.card');
			card.showList = true;
			card.message = "There's no more available Field!";
			c.set('v.card', card);

			h.getProtentialScore(c);
		})
		$A.enqueueAction(action);
	},
	getScore: function(c){
		var fields = c.get('v.fields');
		var missingFields = c.get('v.missingFields');
		missingFields.splice(0, missingFields.length);
		var tempScore = 0;
		var validField = 0;
		var totalPoint = 0;
		if(fields != null && fields.length > 0){
			for(var i = 0; i < fields.length; i++){
				totalPoint += fields[i].importance;
				if(fields[i].value != null && fields[i].value != ''){
					validField += fields[i].importance;
				}else{
					missingFields.push(fields[i]);
					console.log('score: ' + fields[i].label);
				}
			}
			tempScore  = validField / totalPoint * 100;
			c.set('v.score', '' + Math.round(tempScore * 100) / 100);
			c.set('v.missingFields', missingFields);
			//c.set('v.protentialScore', '' + Math.round(tempScore * 100) / 100);
		}
	},
	getProtentialScore: function(c){
		var fields = c.get('v.fields');
		var missingFields = c.get('v.missingFields');
		var tempScore = 0;
		var validField = 0;
		var totalPoint = 0;
		if(fields != null && fields.length > 0){
			for(var i = 0; i < fields.length; i++){
				totalPoint += fields[i].importance;
				if(fields[i].value != null && fields[i].value != ''){
					validField += fields[i].importance;
					console.log('Pscore1: ' + fields[i].label);
				}else{
					console.log(missingFields);
					for(var j = 0; j < missingFields.length; j++){
						if(missingFields[j].label == fields[i].label){
							console.log('Pscore2: ' + fields[i].label);
							if(missingFields[j].value != null && missingFields[j].value != ''){
								validField += missingFields[j].importance;
								j = missingFields.length;
								console.log('Pscore3: ' + fields[i].label);
							}
						}
					}
				}
			}
			tempScore  = validField / totalPoint * 100;
			c.set('v.protentialScore', '' + Math.round(tempScore * 100) / 100);
		}
	},
	getKeyFields : function(){
		var keyFields = [];
		keyFields.push('lastname');
		keyFields.push('firstname');
		keyFields.push('company');
		return keyFields;
	},
	updateRecord : function(c,h){
		var record = c.get('v.record');
		var missingFields = c.get('v.missingFields');
		var action = c.get('c.callService');

		if(missingFields.length == 0 || record == null || record.length == 0){
			//do nothing if there's no fields availble for Update
			return;
		}

		action.setParams({ mapValues: record, isFinalCall: true });
		action.setCallback(this, function(response) {
			console.log('updateRecord');
			console.log(response);
			
			var mapResponse;
			mapResponse = JSON.parse(response.getReturnValue());
			if(mapResponse == null || mapResponse == {}){
				c.set('v.score', 'Error - Can not update Record');
				return;
			}

			location.reload();
			
		})
		$A.enqueueAction(action);
	},

	config: {
		categories: {
			'Website': {
				importance: 1,
				fields: ['Website', 'email']
			},
			'Phone':  {
				importance: 1,
				fields: ['mobile', 'fax']
			},
			'Address':  {
				importance: 1,
				fields: ['billing', 'shipping']
			}
		}
	}
})