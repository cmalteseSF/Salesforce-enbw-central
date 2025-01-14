global class EncryptionHandler implements vlocity_cmt.VlocityOpenInterface{
    
    public Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName.equalsIgnoreCase('decrypt')){
            String decryptedString = EncryptionUtil.decrypt((String)input.get('encryptedData'), (String)input.get('key'));
            System.debug('decryptedString: ' + decryptedString);
            if(!String.isEmpty(decryptedString)){
                outMap.put('decryptedData', decryptedString);
                return true;
            }
        }
        return false;
     }
}