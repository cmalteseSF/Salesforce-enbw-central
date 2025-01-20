public with sharing class EncryptionUtil {
/*test clasees hotfix0004*/
    public static String encrypt(final String clearText, final String key) 
    {
        final Blob encrypted = Crypto.encryptWithManagedIV(
            'AES256',
            EncodingUtil.base64Decode(key),
            Blob.valueOf(clearText)
        );
        return EncodingUtil.urlEncode(EncodingUtil.base64Encode(encrypted), 'UTF-8');
    }

    public static String decrypt(String encryptedData, String key) 
    {
        encryptedData = EncodingUtil.urlDecode(encryptedData,'UTF-8');
        Blob decrypted = Crypto.decryptWithManagedIV(
            'AES256', 
            EncodingUtil.base64Decode(key), 
            EncodingUtil.base64Decode(encryptedData));
        return decrypted.toString();
    }
}