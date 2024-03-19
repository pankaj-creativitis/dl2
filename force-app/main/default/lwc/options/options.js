import { LightningElement, api, track } from 'lwc';
import getOptions from "@salesforce/apex/OptionsController.getOptionsFromMeta";
import CHECK_ICON from '@salesforce/resourceUrl/check_orange';
import IMG_ZIP from '@salesforce/resourceUrl/optionImages3';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationBackEvent } from 'lightning/flowSupport';

export default class Options extends LightningElement {
    imgUrl;
    @api optionType;
    @api optionTitle;

    @api headerAlignCenter;
    @api showDesc;
    @api filterValue;
    @api hoverColor;
    @api borderColor;
    @api showNextPrevious;
    @api
    availableActions = [];

    // @api multiSelect;
    @api isMultiSelect;
    @api hasImage;
    @api imageWidth;
    @api imageRadius;
    @api imageMargin;
    @api imagePosition; // hardcode to relative and remove
    @api borderAdjustment;
    @api actionButton;
    @api actionButtonText;



    // @api outputType;
    @api outputValue;
    @api selectedItem;

    isSingleSelect;
    // fixHeader = false;
    outBoxMargin;
    isCard;
    isList;
    unselect = false;
    addSelection = false;
    newSelection = false;
    mandatoryError = false;
    // singleSelection;

     icnCheck = CHECK_ICON;

    @track imageUrl;
    @track displayData;


    connectedCallback() {

        if (this.optionType == 'card') {
            this.isCard = true;
            this.isList = false;
        } else {
            this.isCard = false;
            this.isList = true;
        }

        this.isSingleSelect = !this.isMultiSelect;

        this.showDesc = this.showDesc;
        this.hoverColor = this.hoverColor;
        getOptions({ filter: this.filterValue, hasImage: this.hasImage })
            .then(data => {
                console.log('data >> ' + JSON.stringify(data));
                let parsedValue = [...data];
                let newData = [];
                parsedValue.forEach(function (arrayItem) {
                    console.log('arrayItem >> ' + JSON.stringify(arrayItem));
                    arrayItem = Object.assign({}, arrayItem, { imgURL: IMG_ZIP + '/' + arrayItem.imgId });
                    // arrayItem.imgId = ;
                    console.log(arrayItem.imgId);
                    newData.push(arrayItem);
                });
                this.displayData = newData;
                // this.error = undefined;
                // console.log('data >> ' + JSON.stringify(data));
            })
            .catch(error => {
                this.error = error;
                alert('error here' + JSON.stringify(error));
                this.displayData = undefined;
            });
    }

    renderedCallback() {

        if (this.isCard) {
            // Set image position, size & radius
            if (this.hasImage) {
                const imgDivs = this.template.querySelectorAll('.img3');

                for (var i = 0; i < imgDivs.length; i++) {
                    imgDivs[i].style.setProperty('--positionVar', this.imagePosition);
                    imgDivs[i].style.setProperty('--marginVar', this.imageMargin);
                    imgDivs[i].style.setProperty('--widthVar', this.imageWidth);
                }

                const imgs = this.template.querySelectorAll('img');
                for (var i = 0; i < imgs.length; i++) {
                    imgs[i].style.borderRadius = this.imageRadius;
                }

            }

            // Set outer-box margin
            const imgMargin = this.imageMargin;
            const outerDivs = this.template.querySelectorAll('.outer-box');
            if (imgMargin.startsWith("-") && this.hasImage) {
                this.outBoxMargin = imgMargin.substring(1, imgMargin.indexOf(' '));
                for (var i = 0; i < outerDivs.length; i++) {
                    outerDivs[i].style.setProperty('--offsetMargin', this.outBoxMargin);
                }
            }

            // Set Title/Header
            const headerDivs = this.template.querySelectorAll('.header');
            if (this.headerAlignCenter) {
                for (var i = 0; i < headerDivs.length; i++) {
                    headerDivs[i].style.setProperty('--titleAlign', 'center');
                    // headerDivs[i].classList.add('slds-align_absolute-center');
                }
            }

            if (this.borderAdjustment) {
                for (var i = 0; i < headerDivs.length; i++) {
                    headerDivs[i].style.setProperty('--paddingTop', this.borderAdjustment);
                    // headerDivs[i].classList.add('slds-align_absolute-center');
                }
            }

            document.documentElement.style.setProperty('--bcgColor', this.hoverColor);
            document.documentElement.style.setProperty('--bdrColor', this.borderColor);
        }

        // selected items on load
        if (this.selectedItem) {
            console.log('in selected on load');
            this.selectedItem = this.selectedItem.replace(/\s*,\s*/g, ",").trim();
            console.log(this.selectedItem);
            var selectedArray = this.selectedItem.split(',');
            console.log('selectedArray >> ' + JSON.stringify(selectedArray));
            if (!this.isList) {
                const addSelections = this.template.querySelectorAll('.inner-box');
                for (var i = 0; i < addSelections.length; i++) {
                    for (var j = 0; j < selectedArray.length; j++) {
                        console.log('addSelections[i] >> ' + addSelections[i].getAttribute('item') + ' <> ' + addSelections[i].getAttribute('name'));
                        console.log('selected value >> ' + selectedArray[j]);
                        if (addSelections[i].getAttribute('data-item') == selectedArray[j] ||
                            addSelections[i].getAttribute('data-name') == selectedArray[j]) {
                            addSelections[i].style.backgroundColor = this.hoverColor;
                        }

                        // console.log('rem selection: ', removeSelections[i]);
                    }
                }
            } else {
                const addListSelections = this.template.querySelectorAll('.listgrid');
                for (var i = 0; i < addListSelections.length; i++) {
                    for (var j = 0; j < selectedArray.length; j++) {
                        if (addListSelections[i].getAttribute('data-item') == selectedArray[j] ||
                        addListSelections[i].getAttribute('data-name') == selectedArray[j]) {
                            // addSelections[i].style.backgroundColor = this.hoverColor;
                            if (addListSelections[i].hasChildNodes()) {
                                let children = addListSelections[i].childNodes;
                                for (let i = 0; i < children.length; i++) {
                                    console.log(children[i].className);
                                    if (children[i].classList.contains('listicon')) {
                                        if (children[i].classList.contains('slds-hidden')) {
                                            children[i].classList.remove("slds-hidden");
                                        }
                                    }
                                }
                            }
                        }
                    }
                }


            }
        }

    }

    handleListItemClicked(e) {
        let selectedVal;
        // output in id or text?
        if (this.outputValue == 'id') {
            selectedVal = e.currentTarget.dataset.item;
        } else {
            selectedVal = e.currentTarget.dataset.name;
        }
        this.getSelectedValues(selectedVal);

        if (!this.isMultiSelect) {
            const removeListSelections = this.template.querySelectorAll('.listicon');
            for (var i = 0; i < removeListSelections.length; i++) {
                removeListSelections[i].classList.add("slds-hidden");
            }
            if (e.currentTarget.hasChildNodes()) {
                let children = e.currentTarget.childNodes;
                for (let i = 0; i < children.length; i++) {
                    console.log(children[i].className);
                    if (children[i].classList.contains('listicon')) {
                        if (children[i].classList.contains('slds-hidden')) {
                            children[i].classList.remove("slds-hidden");
                            break;
                        }
                    }
                }
            }
        } else {
            if (e.currentTarget.hasChildNodes()) {
                let children = e.currentTarget.childNodes;
                // console.log('children >> ' + JSON.stringify(children));
                for (let i = 0; i < children.length; i++) {
                    console.log(children[i].className);
                    if (children[i].classList.contains('listicon')) {
                        if (children[i].classList.contains('slds-hidden')) {
                            children[i].classList.remove("slds-hidden");
                            break;
                        } else {
                            children[i].classList.add("slds-hidden");
                            break;
                        }
                    }
                }
            }
        }
    }

    handleItemClicked(e) {
        let selectedVal;
        // output in id or text?
        if (this.outputValue == 'id') {
            selectedVal = e.currentTarget.dataset.item;
        } else {
            selectedVal = e.currentTarget.dataset.name;
        }
        this.getSelectedValues(selectedVal);

        if (!this.isMultiSelect) {
            // var removeSelections = this.template.querySelectorAll('.inner-box');
            const removeSelections = this.template.querySelectorAll('.inner-box');
            for (var i = 0; i < removeSelections.length; i++) {
                removeSelections[i].style.backgroundColor = '';
                // console.log('rem selection: ', removeSelections[i]);
            }
            e.currentTarget.style.backgroundColor = this.hoverColor;
        } else {
            if (this.unselect) {
                console.log('innit unselect');
                e.currentTarget.style.backgroundColor = null;
                this.unselect = false;
            } else if (this.addSelection || this.newSelection) {
                console.log('innit addSelection or newSelection');
                e.currentTarget.style.backgroundColor = this.hoverColor;
                this.addSelection = false;
                this.newSelection = false;
            }
        }
    }

    getSelectedValues(newSelection) {
        if (this.isMultiSelect) {
            if (this.selectedItem) {
                if (this.selectedItem.includes(newSelection)) {
                    this.selectedItem = this.selectedItem.replace(newSelection, '');
                    if (this.selectedItem.charAt(0) == ',') {
                        this.selectedItem = this.selectedItem.substring(1);
                    }
                    if (this.selectedItem.slice(-1) == ',') {
                        this.selectedItem = this.selectedItem.slice(0, -1);
                    }
                    if (this.selectedItem.includes(',,')) {
                        this.selectedItem = this.selectedItem.replace(',,', ',');
                    }
                    this.unselect = true;
                } else {
                    this.selectedItem = this.selectedItem + ',' + newSelection;
                    this.addSelection = true;
                }
            } else {
                this.selectedItem = newSelection;
                this.newSelection = true;
            }
        } else {
            this.selectedItem = newSelection;
        }
        console.log(this.selectedItem);
    }

    handleClick() {
        // check if NEXT is allowed on this screen
        if (this.availableActions.find(action => action === 'NEXT')) {
            // navigate to the next screen
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }


    handlePrevious() {
        // check if NEXT is allowed on this screen
        if (this.availableActions.find(action => action === 'BACK')) {
            // navigate to the next screen
            const navigateBackEvent = new FlowNavigationBackEvent();
            this.dispatchEvent(navigateBackEvent);
        }
    }

    handleNext() {
        if (this.selectedItem) {
            // check if NEXT is allowed on this screen
            if (this.availableActions.find(action => action === 'NEXT')) {
                // navigate to the next screen
                const navigateNextEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(navigateNextEvent);
            }
        } else {
            this.mandatoryError = true;
        }
    }
}