public with sharing class Mppt {

    public String PID;  // Product ID
	public Integer FW;  // Firmware version of controller
	public String SER;  // Serial number
	public Integer V;   // Battery voltage, mV
	public Integer I;   // Battery current, mA
	public Integer VPV; // Panel voltage, mV
	public Integer PPV; // Panel power, W
	public Integer CS;  // Charge state
	public Integer ERR; // Error code, 0 to 119
	public String LOAD; // Load output state, ON/OFF
	public Integer IL;  // Load current, mA
	public Integer H19; // Yield total, Wh
	public Integer H20; // Yield today, Wh
	public Integer H21; // Maximum power today, W
	public Integer H22; // Yield yesterday, Wh
	public Integer H23; // Maximum power yesterday, W
	public Integer HSDS;// Day sequence number, 0 to 365
	public Integer Checksum;// Message checksum

    public Mppt() {

    }

    public Decimal getPanelVoltage() {
        return Decimal.valueOf(''+(this.VPV / 1000.0));
    }

    public Decimal getBatteryVoltage() {
        return Decimal.valueOf(''+(this.V / 1000.0));
    }

    public Decimal getBatteryCurrent() {
        return Decimal.valueOf(''+(this.I / 1000.0));
    }

	public static Mppt parse(String json) {
		return (Mppt) System.JSON.deserialize(json, Mppt.class);
	}
}