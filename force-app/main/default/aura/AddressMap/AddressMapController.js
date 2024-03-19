({
    init: function (cmp, event, helper) {

        var mapMarkers = [
        {
            location: {
                // Location Information
                // City: 'Nagpur',
                // Country: 'India',
                // PostalCode: '440034',
                // State: 'Maharashtra',
                // Street: 'Plot n. 62, gopalkrishna layout, Beldar Nagar, Narsala road',
                // 2425 Peel Ave, Orlando, FL 32806, USA
                
                City: 'Orlando',
                Country: 'United States',
                PostalCode: '32806',
                State: 'FL',
                Street: '2425 Peel Ave',
                
            },

            // For onmarkerselect
            value: 'SF1',

            // Extra info for tile in list and info window
            icon: 'standard:visits',
            // title: 'Address from Aadhaar', // e.g. Account.Name
            title: 'Address from KYC Document', // e.g. Account.Name
            description: 'This is a long description'
        },
        {
            location: {
                // Location Information 9001 E Colonial Dr, Orlando, FL 32817, United States
                // 21.104810, 79.136548
                City: 'Orlando',
                Country: 'United States',
                PostalCode: '32817',
                State: 'FL',
                Street: '9001 E Colonial Dr',
                // City: 'Nagpur',
                // Country: 'India',
                // PostalCode: '440034',
                // State: 'Maharashtra',
                // Street: '36, Nirala Society, Taj Bagh'

            },

            // For onmarkerselect
            value: 'SF2',

            // Extra info for tile in list
            icon: 'custom:custom16',
            // title: 'Service Territory Bank', // e.g. Account.Name Greenway Ford
            title: 'Nearest LendKey Branch - Greenway',
        }
    ];

    cmp.set('v.mapMarkers', mapMarkers);
    },

    handleMarkerSelect: function (cmp, event, helper) {
        var marker = event.getParam("selectedMarkerValue");
    }
})