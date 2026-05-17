//consume reference of my DB tables
using { cap.cds } from '../db/CDSViews';

service CDSService @(path:'CDSService') {

    ///SELECT * FROM view
    entity ProductSet as projection on cds.CDSViews.ProductView{
        *,
        //never be persisted in db
        virtual soldCount: Int16
    };
    entity ItemsSet as projection on cds.CDSViews.ItemView;

}