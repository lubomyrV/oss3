public with sharing class CryptoUtil {

    public class CryptoExample {

        public void test(){
            this.aes128();
            this.aes192();
            this.aes256();
        }
    
        public void aes128(){
            //text to encrypt
            String clearText = 'the quick brown fox jumps over the lazy dog';
    
            //16 byte string. since characters used are ascii, each char is 1 byte.
            Blob key = Blob.valueOf('1234567890123456');
            //encrypted blob
            Blob cipherText = Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(clearText));
            //encrypted string
            String encodedCipherText = EncodingUtil.base64Encode(cipherText);
    
            System.debug(encodedCipherText);
    
            //encrypted blob
            Blob encodedEncryptedBlob = EncodingUtil.base64Decode(encodedCipherText);
            //decrypted blob
            Blob decryptedBlob = Crypto.decryptWithManagedIV('AES128', key, encodedEncryptedBlob);
            //decrypted string
            String decryptedClearText = decryptedBlob.toString();
    
            System.debug(decryptedClearText);
        }
    
        public void aes192(){
            String clearText = 'the quick brown fox jumps over the lazy dog';
            //24 byte string. since characters used are ascii, each char is 1 byte.
            Blob key = Blob.valueOf('123456789012345678901234');
            Blob cipherText = Crypto.encryptWithManagedIV('AES192', key, Blob.valueOf(clearText));
            String encodedCipherText = EncodingUtil.base64Encode(cipherText); 
            System.debug(encodedCipherText);
            Blob encodedEncryptedBlob = EncodingUtil.base64Decode(encodedCipherText);
            Blob decryptedBlob = Crypto.decryptWithManagedIV('AES192', key, encodedEncryptedBlob);
            String decryptedClearText = decryptedBlob.toString();
            System.debug(decryptedClearText);
        }
    
        public void aes256(){
            String clearText = 'the quick brown fox jumps over the lazy dog';
            //32 byte string. since characters used are ascii, each char is 1 byte.
            Blob key = Blob.valueOf('12345678901234567890123456789012');
            Blob cipherText = Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf(clearText));
            String encodedCipherText = EncodingUtil.base64Encode(cipherText); 
            System.debug(encodedCipherText);
            Blob encodedEncryptedBlob = EncodingUtil.base64Decode(encodedCipherText);
            Blob decryptedBlob = Crypto.decryptWithManagedIV('AES256', key, encodedEncryptedBlob);
            String decryptedClearText = decryptedBlob.toString();
            System.debug(decryptedClearText);
        }
    }

    public enum CryptoAlgorithmType { AES128, AES192, AES256 }
    public enum HashAlgorithmType { MD5, SHA1, SHA3_256, SHA3_384, SHA3_512, SHA_256, SHA_512 }
    public enum KeySizeType { K128, K192, K256 }
    
    public CryptoUtil() {
        cryptoAlgorithm = CryptoAlgorithmType.AES256;
        hashAlgorithm = HashAlgorithmType.SHA3_512;
        keySize = KeySizeType.K256;
    }

    public CryptoUtil(CryptoAlgorithmType cryptoAlgorithm, HashAlgorithmType hashAlgorithm, KeySizeType keySize) {
        this.cryptoAlgorithm = cryptoAlgorithm;
        this.hashAlgorithm = hashAlgorithm;
        this.keySize = keySize;
    }

    public String encryptData() {
        if (this.data == null) throw new HandledException('Data is null');
        setHash();
        if (this.key == null) {
            this.key = Crypto.generateAesKey(keySizeMap.get(keySize));
        }
        Blob encryptedData = Crypto.encryptWithManagedIV(cryptoAlgorithm.toString(), this.key, Blob.valueOf(this.data));
        this.data = EncodingUtil.base64Encode(encryptedData);
        return this.data;
	}

    public Blob decryptData(String key, String data) {
        Blob dencryptedData = Crypto.decryptWithManagedIV(
            cryptoAlgorithm.toString(), 
            EncodingUtil.base64Decode(key), 
            EncodingUtil.base64Decode(data)
        );
        return dencryptedData;
	}

    public void setData(String data) {
        this.data = data;
        setHash();
	}

    public String getData() {
        return this.data;
	}

    public String getHash(String data) {
        Blob hash = Crypto.generateDigest(hashAlgorithmMap.get(hashAlgorithm), Blob.valueOf(data));
        return EncodingUtil.base64Encode(hash);
	}

    private void setHash() {
        this.hash = Crypto.generateDigest(hashAlgorithmMap.get(hashAlgorithm), Blob.valueOf(this.data));
	}

    private String data; // A data that caused the error 
    public Blob key;  // An AES key, in order to decrypted the data
    private Blob hash; // A hash for the data
    private CryptoAlgorithmType cryptoAlgorithm; // Valid values: 'AES128', 'AES192' and 'AES256'
    private HashAlgorithmType hashAlgorithm; // Valid values: 'MD5', 'SHA1', 'SHA3-256', 'SHA3-384', 'SHA3-512', 'SHA-256' and 'SHA-512'
    private KeySizeType keySize; // Valid values: 128, 192 or 256

    private Map<HashAlgorithmType, String> hashAlgorithmMap = new Map<HashAlgorithmType, String> {
        HashAlgorithmType.MD5 => 'MD5', 
        HashAlgorithmType.SHA1 => 'SHA1', 
        HashAlgorithmType.SHA3_256 => 'SHA3-256', 
        HashAlgorithmType.SHA3_384 => 'SHA3-384', 
        HashAlgorithmType.SHA3_512 => 'SHA3-512', 
        HashAlgorithmType.SHA_256 => 'SHA-256', 
        HashAlgorithmType.SHA_512 => 'SHA-512'
    };

    private Map<KeySizeType, Integer> keySizeMap = new Map<KeySizeType, Integer> {
        KeySizeType.K128 => 128, 
        KeySizeType.K192 => 192, 
        KeySizeType.K256 => 256
    };
}