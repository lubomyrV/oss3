public with sharing class OopDemo {

    public virtual class VCompany {
        private String companyAddress;
        protected String companyName;
        public VCompany(String companyName) {
            this.companyName = companyName;
            this.companyAddress = companyName + ' address';
        }
        public virtual String getCompanyName() {
            System.debug('From VCompany '+companyName);
            return companyName;
        }
    }

    public class PrimaryCompany extends VCompany {
        public PrimaryCompany(String companyName) {
            super(companyName);
        }

        public override String getCompanyName() {
            System.debug('From PrimaryCompany '+companyName);
            return companyName;
        }
    }

    public class SecondaryCompany extends VCompany {
        public SecondaryCompany(String companyName) {
            super(companyName);
        }
    }

    public abstract class APurchase {
        protected Double discount;
        public APurchase() {}
        public APurchase(Decimal discount) {
            this.discount = discount;
        }
        abstract public Decimal getDiscount();
        public virtual void printDiscount() {
            System.debug('printDiscount from abstract class '+discount);
        }
        public Decimal getProtectedDiscount() {
            return discount;
        }
    }

    public with sharing class PurchaseExample extends APurchase {
        public PurchaseExample(Decimal discount) {
            this.discount = discount;
        }
        public PurchaseExample() {
            super(0.3);
        }
    
        public override Decimal getDiscount(){
            System.debug('getDiscount from PurchaseExample class ');
            return this.discount;
        }
    
    }

    public interface IWorker {
        Double increaseWorkerSallary(Double currentSalarry);
    }

    public class Worker1 implements IWorker{
        public Worker1() {
    
        }
        public Double increaseWorkerSallary(Double currentSalarry){
            Double salarry = currentSalarry * 1.3;
            System.debug('Worker1: ' + salarry);
            return salarry;
        }
    }

    public void run() {
        VCompany vc1 = new VCompany('companyName1');
        System.debug('Virtual class VCompany ' + vc1.getCompanyName());

        VCompany sc2 = new SecondaryCompany('companyName2');
        System.debug('SecondaryCompany extends VCompany ' + sc2.getCompanyName());

        VCompany pc1 = new PrimaryCompany('companyName4');
        System.debug('PrimaryCompany extends VCompany ' + pc1.getCompanyName());

        SecondaryCompany sc3 = new SecondaryCompany('companyName5');
        System.debug('SecondaryCompany extends VCompany ' + sc3.getCompanyName());
        


        // Error: Abstract classes cannot be constructed
        // APurchase ap1 = new APurchase('companyName1');
        // System.debug('Abstract class APurchase ' + ap1);

        APurchase ap2 = new PurchaseExample(0.75);
        System.debug('PurchaseExample extends APurchase ' + ap2);

        IWorker w1 = new Worker1();
        System.debug('Worker1 implements IWorker ' + w1);
    }
}