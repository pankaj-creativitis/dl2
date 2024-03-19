({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Opportunity name', fieldName: 'opportunityName', type: 'text', editable: true, typeAttributes: { required: true }},
            {
                label: 'Close date', fieldName: 'closeDate', type: 'date', editable: true,
                typeAttributes: {
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit'
                }
            },
            {label: 'Confidence', fieldName: 'confidence', type: 'percent', editable: true },
            {label: 'Amount', fieldName: 'amount', type: 'currency', typeAttributes: { currencyCode: 'USD'}, editable: true, typeAttributes: { required: true } },
            {label: 'Contact Email', fieldName: 'contact', type: 'email', editable: true },
            {label: 'Contact Phone', fieldName: 'phone', type: 'phone', editable: true},
            {label: 'Website', fieldName: 'website', type: 'url', typeAttributes: { target: '_parent' }, editable: true }
        ]);

        helper.initServer().then($A.getCallback(function () {
            helper.fetchData(cmp)
        }));
    },
    handleSaveEdition: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');

        helper.saveEdition(cmp, draftValues);
    },
    handleCancelEdition: function (cmp) {
        // do nothing for now...
    }
})