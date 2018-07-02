({
    centralize : function () {
        var modal = $(this),
            dialog = modal.find('.modal-dialog');
        modal.css('display', 'block');
        dialog.css("margin-top", Math.max(0, ($(window).height() - dialog.height()) / 2));
    },
    setJSON : function () {
		return {
            "entries" : [
            	{
            		"title" : $A.get("$Label.et4ae5.TITLE"),
                    "body" : $A.get("$Label.et4ae5.msg0206")
        		},
                {
                    "title" : $A.get("$Label.et4ae5.TITLE"),
                    "body"  : $A.get("$Label.et4ae5.msg0206")
                }
    		]
      	};
    },
})