({
	handleMouseHoverPatient: function(component, event, helper) {
        var recId = event.srcElement.id;
        component.set("v.hoveredRecId",recId);
        component.set("v.patientNameToggleHover",true);
    },
    handleMouseOutPatient: function(component, event, helper) {
        component.set("v.patientNameToggleHover",false);
    },
    
    handleMouseHoverReportId: function(component, event, helper) {
        var recId = event.srcElement.id;
        component.set("v.hoveredRecId",recId);
        component.set("v.reportIdToggleHover",true);
    },
    handleMouseOutReportId: function(component, event, helper) {
        component.set("v.reportIdToggleHover",false);
    },
    
    handleClickReportId: function(component, event, helper) {
        var recId = event.srcElement.id;
        $A.createComponent("c:ResultsInboxResultDetailPopUpPOC", {
            recordId: recId
        }, function (message, status) {
            if (status === "SUCCESS") {
                helper.openOverlayModal(component, 'Result Detail', message, null, 'info', true, 'resultDetail');
            }
        });
    }
})