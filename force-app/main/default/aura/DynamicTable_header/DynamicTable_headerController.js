({
    sort: function(cmp, evt, help) {
        //All declared variables
        let notempty;
        let emptydata;
        let colname = evt.currentTarget.id;
        let data = JSON.parse(JSON.stringify(cmp.get('v.rowData')));
        let headerData = JSON.parse(JSON.stringify(cmp.get('v.colData')));
        // Perform Actions
        notempty = data.filter(val => {
            return (val.hasOwnProperty(colname))
        })
        emptydata = data.filter(val => {
            return !(val.hasOwnProperty(colname))
        })
        headerData.forEach(obj => {
            if (obj['fieldPath'] == colname) {
                if (obj['isSortUp'] == true) {
                    notempty.sort(help.sortDown(colname));
                    cmp.set('v.rowData', emptydata.length > 0 ? notempty.concat(emptydata) : notempty)
                    obj['isSortUp'] = false
                    obj['isSortDown'] = true
                } else {
                    notempty.sort(help.sortUp(colname));
                    cmp.set('v.rowData', emptydata.length > 0 ? emptydata.concat(notempty) : notempty)
                    obj['isSortUp'] = true
                    obj['isSortDown'] = false
                }
                obj['byDefaultSort'] = true
            } else obj['byDefaultSort'] = false
        });
        cmp.set('v.colData', headerData);
    },
        
    calculateWidth : function(cmp, evt, help) {
            var childObj = evt.target
            var parObj = childObj.parentNode;
            var count = 1;
            while(parObj.tagName != 'TH') {
                parObj = parObj.parentNode;
                count++;
            }
            console.log('final tag Name'+parObj.tagName);
            var mouseStart=evt.clientX;
            cmp.set("v.mouseStart",mouseStart);
            cmp.set("v.oldWidth",parObj.offsetWidth);
    },
    setNewWidth : function(cmp, evt, help) {
            var childObj = evt.target
            var parObj = childObj.parentNode;
            var count = 1;
            while(parObj.tagName != 'TH') {
                parObj = parObj.parentNode;
                count++;
            }
            var mouseStart = cmp.get("v.mouseStart");
            var oldWidth = cmp.get("v.oldWidth");
            var newWidth = evt.clientX- parseFloat(mouseStart)+parseFloat(oldWidth);
            parObj.style.width = newWidth+'px';
    }
})