using { cap.db.master, cap.db.transaction } from '../db/datamodel';

service CatalogService @(path: 'CatalogService', requires: 'authenticated-user') {

    //Entity  - representation of an end point of data to perform CRUDQ tasks
    entity EmployeeSet @(restrict :[
                                {grant : ['READ'], to: 'Viewer',
                                    //row level security
                                    where :'bankName = $user.spiderman'},
                                {grant : ['WRITE', 'DELETE'], to: 'Editor'}
                              ]) 
                              as projection on master.employee;
                              // entity EmployeeSet as projection on master.employee;
    entity ProductSet as projection on master.product;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet as projection on master.address;
    //@readonly
    //@Capabilities : { Deletable : false }
    entity PurchaseOrderSet @(
                              restrict :[
                                {grant : ['READ'], to: 'Viewer',
                                where :'TAX_AMOUNT = $user.tax'},
                                {grant : ['WRITE', 'DELETE'], to: 'Editor'}
                              ],
                              odata.draft.enabled: true,
                              Common.DefaultValuesFunction: 'getDeafultValue' ) as projection on transaction.purchaseorder{
        *,
        //CDS Expression language
        
        
    }
    actions{
        ///Side effect - a trigger to my action leads to a change of a field value in data
        //this force framework to make a GET call after action is triggred to load data
        //_anubhav is  variable that will contain the updated data coming from BE
        @cds.odata.bindingparameter.name: '_anubhav'
        @Common.SideEffects :{
            TargetProperties: ['_anubhav/GROSS_AMOUNT','_anubhav/OVERALL_STATUS']
        }
        //the system will pass the PO primary key - NODE_KEY automatically to input 
        action boost() returns PurchaseOrderSet
    };
    entity PurchaseItemsSet as projection on transaction.poitems;

    //non instance bound because they are not connected to any entity
    function getLargestOrder() returns array of PurchaseOrderSet;
    function getDeafultValue() returns PurchaseOrderSet;

}