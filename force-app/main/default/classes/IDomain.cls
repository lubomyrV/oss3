/**
 * Domain Layer 
 * The domain layer is home to sObject manipulation. 
 * The domain class also handles the trigger methods. 
 * The aim is to keep logic deduplicated and central.
 */
public interface IDomain {
    void triggerHandler();
}