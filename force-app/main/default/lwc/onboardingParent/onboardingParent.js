import { LightningElement, api } from 'lwc';

export default class OnboardingParent extends LightningElement {
    @api currentStage;
    @api objectApi;
    @api recId;
    @api fldArray;

    @api showRelated;
    @api showDetails;
    @api showEsg;

    @api title;
    @api childObjectName;
    @api parentFieldAPI;
    @api fieldsArray;

}