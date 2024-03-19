import { LightningElement } from 'lwc';
import bankerImg from '@salesforce/resourceUrl/Banker';
import uploadDataImg from '@salesforce/resourceUrl/UploadData';
import esgImg from '@salesforce/resourceUrl/ESGDetails';
import logoutImg from '@salesforce/resourceUrl/logout';
import cautionImg from '@salesforce/resourceUrl/caution';

export default class EsgMenu extends LightningElement {
    bankerIcon = bankerImg;
    uploadDataIcon = uploadDataImg;
    esgIcon = esgImg;
    logoutIcon = logoutImg;
    cautionIcon = cautionImg;
}