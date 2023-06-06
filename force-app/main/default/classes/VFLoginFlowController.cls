public class VFLoginFlowController {

    public PageReference FinishLoginFlowStartUrl() {
        //do stuff
        
        system.debug('from FinishLoginFlowStartUrl');
        //finish the login flow and send you to the startUrl (account page in this case)
        TigerEyeAPI api = new TigerEyeAPI();
        api.buildRequest1();
        system.debug('test');   
        return null;
        //return Auth.SessionManagement.finishLoginFlow('/001');
    }


    public PageReference FinishLoginFlowHome() {
        //do stuff
        
        //finish the login flow and send you the default homepage
        system.debug('from FinishLoginFlowhome');
        return Auth.SessionManagement.finishLoginFlow();
    }
}