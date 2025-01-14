@RestResource(UrlMapping='/portal/*')
global class PortalRestService {
    public static String recordId;
    public static Blob quoteDetails;

    public static RestRequest request = RestContext.request;
    public static RestResponse response = RestContext.response;

    public static Map<String, Object> responseBody = new Map<String, Object>();

    @HttpGet
    global static void getQuoteDetails() {
        System.debug('getQuoteDetails method is start');
        
        String procedureName = 'PlusNet_ProvideQuoteRelatedDetailsToPortal';
        Map<String, Object> ipInput = new Map<String, Object> ();
        Map<String, Object> ipOutput = new Map<String, Object> ();
        Map<String, Object> ipOptions = new Map<String, Object> ();

        try {
            response.addHeader('Content-Type', 'application/json');

            if(request.params.isEmpty() || request.params.get('quoteId') == null)
                throw new IllegalArgumentException('Input param quoteId is missing or not valid.');
            
            recordId = request.params.get('quoteId');
            System.debug('recordId: ' + recordId);

            ipInput.put('EncryptedData', recordId);

            ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);
            System.debug('ipOutput: ' + JSON.serialize(ipOutput));

            if(!ipOutput.isEmpty() && ipOutput.get('success') != null && ipOutput.get('success') == true)
                setSuccessfulGETResponse(ipOutput);
            else 
                setUnsuccessfulGETResponse(ipOutput);
        } catch (Exception error) {
            System.debug('error: ' + error.getMessage());
            setUnsuccessfulGETResponse(error.getMessage());
        }

        System.debug('getQuoteDetails method is end');
    }

    @HttpPost
    global static void updateQuoteDetails() {
        System.debug('updateQuoteDetails method is start');

        String procedureName = 'PlusNet_SaveQuoteStatusFromPortal';
        Map<String, Object> ipInput = new Map<String, Object> ();
        Map<String, Object> ipOutput = new Map<String, Object> ();
        Map<String, Object> ipOptions = new Map<String, Object> ();

        try {
            response.addHeader('Content-Type', 'application/json');

            if(request.params.isEmpty() || request.params.get('quoteId') == null)
                throw new IllegalArgumentException('Input param quoteId is missing or not valid.');
            
            recordId = request.params.get('quoteId');
            System.debug('recordId: ' + recordId);
            
            ipInput.put('EncryptedData', recordId);
            ipInput.put('quoteDetails', JSON.deserializeUntyped(request.requestBody.toString()));
            System.debug('quoteDetails: ' + JSON.serialize(ipInput));
            
            ipOutput = (Map<String, Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);
            System.debug('ipOutput: ' + JSON.serialize(ipOutput));

            if(!ipOutput.isEmpty() && ipOutput.get('success') != null && ipOutput.get('success') == true)
                setSuccessfulPOSTResponse(ipOutput);
            else 
                setUnsuccessfulPOSTResponse(ipOutput);
        } catch (Exception error) {
            System.debug('error: ' + error.getMessage());
            setUnsuccessfulPOSTResponse(error.getMessage());
        }
    }

    private static void setSuccessfulGETResponse(Map<String, Object> ipOutput) {
        response.statusCode = 200;
        response.responseBody = Blob.valueOf(JSON.serialize(ipOutput));
    }

    private static void setUnsuccessfulGETResponse(Map<String, Object> ipOutput) {
        response.statusCode = 400;
        response.responseBody = Blob.valueOf(JSON.serialize(ipOutput));
    }

    private static void setUnsuccessfulGETResponse(String message) {
        responseBody.put('error', message);
        response.statusCode = 400;
        response.responseBody = Blob.valueOf(JSON.serialize(responseBody));
    }

    private static void setSuccessfulPOSTResponse(Map<String, Object> ipOutput) {
        response.statusCode = 200;
        response.responseBody = Blob.valueOf(JSON.serialize(ipOutput));
    }

    private static void setUnsuccessfulPOSTResponse(Map<String, Object> ipOutput) {
        response.statusCode = 400;
        response.responseBody = Blob.valueOf(JSON.serialize(ipOutput));
    }

    private static void setUnsuccessfulPOSTResponse(String message) {
        responseBody.put('error', message);
        response.statusCode = 400;
        response.responseBody = Blob.valueOf(JSON.serialize(responseBody));
    }

}