
enum ReportingPeriod {
  today('Today'),
  weekToDate('Week To Date'),
  lastWeek('Last Week'),
  monthToDate('Month To Date'),
  lastMonth('Last Month'),
  yearToDate('Year to Date'),
  lastYear('Last Year');

  const ReportingPeriod(this.label);

  final String label;
}

enum StockLevelState {
  inStock('In Stock'),
  reorder('For Reorder'),
  lowStock('Low Stock'),
  outOfStock('Out of Stock');

  final String label;

  const StockLevelState(this.label);
}

enum IncomingInventoryState {
  forPlacement('For Placement'),
  forConfirmation('For Confirmation'),
  forDelivery('For Delivery'),
  forInventory('For Inventory');

  final String label;

  const IncomingInventoryState(this.label);
}

enum InventoryAdjustmentReason {
  shrinkageTheft('Shrinkage or Theft'),
  damagedObsolete('Damaged or Obsolete Goods'),
  countingErrors('Counting Errors'),
  supplierReturns('Supplier Returns'),
  expirySpoilage('Expiry or Spoilage'),
  sampleDisplayItems('Sample or Display Items'),
  overstocking('Overstocking'),
  stockTransfer('Stock Transfer'),
  productionScrap('Production Scrap'),
  reconciliation('Reconciliation'),
  dataEntryErrors('Data Entry Errors'),
  salesReturns('Sales Returns'),
  giftsPromotionalItems('Gifts or Promotional Items'),
  newInventory('New Inventory'),
  customerOrdersPendingShipment('Customer Orders Pending Shipment'),
  supplierShipmentsPendingReceipt('Supplier Shipments Pending Receipt'),
  regulatoryComplianceChanges('Regulatory or Compliance Changes'),
  marketValueAdjustments('Market Value Adjustments'),
  auditFindings('Audit Findings');

  const InventoryAdjustmentReason(this.label);

  final String label;
}

enum PlaceOrderState { orderNotPlaced, loading, orderPlaced, disabled }

enum ConfirmOrderState { orderNotConfirmed, loading, orderConfirmed, disabled }

enum DeliveryState {
  deliveryNotConfirmed,
  loading,
  deliveryConfirmed,
  disabled
}

enum SalesOrderState {
  onHold('On Hold'),
  forRelease('For Release');

  const SalesOrderState(this.label);

  final String label;
}

enum SaleType {
  retail('Retail'),
  account('Account');

  final String label;

  const SaleType(this.label);
}

enum PaymentTerm {
  cash('Cash', 'Payment is due on order'),
  dueOnReceipt('Due on Receipt',
      'Payment is due immediately upon receipt of the invoice.'),
  cashOnDelivery('Cash on Delivery',
      'Payment is made at the time of delivery of goods or services.'),
  net30('Net 30', 'Payment is due 30 days from the date of the invoice.'),
  net60('Net 60', 'Payment is due 60 days from the date of the invoice.'),
  net90('Net 90', 'Payment is due 90 days from the date of the invoice.'),
  advancePayment('Advance Payment',
      'The customer pays in full before the goods or services are delivered.'),
  partialPayment('Partial Payment',
      'Payment is made in installments over a specified period.'),
  paymentInAdvance('Payment in Advance',
      'A percentage of the total invoice amount is paid upfront.'),
  progressPayments('Progress Payments',
      'Payments are made at specific milestones or as work progresses.'),
  letterOfCredit('Letter of Credit',
      'Payment is guaranteed by a bank, and the seller receives payment upon meeting the terms and conditions specified in the LC.'),
  openAccount('Open Account',
      'The buyer is extended credit, and payment is due within an agreed-upon period.'),
  endOfMonth('End of Month',
      'Payment is due at the end of the current month, following the date of the invoice.'),
  receiptOfGoods('Receipt of Goods',
      'Payment is due upon the receipt of goods by the buyer.'),
  codNet10('COD Net 10', 'Payment is due 10 days from the date of delivery.'),
  twoTenNet30('2/10 Net 30',
      'A 2% discount is offered if payment is made within 10 days; otherwise, the full amount is due in 30 days.');

  final String label;
  final String description;

  const PaymentTerm(this.label, this.description);
}

enum CustomerType {
  individual('Individual'),
  organization('Business/Organization');

  final String label;

  const CustomerType(this.label);
}

enum InventoryLocationType {
  warehouse('Warehouse',
      'A large facility or space used for the storage and handling of inventory items'),
  area('Area', 'A designated area within a space for inventory'),
  zone('Zone', 'A designated zone within a space for inventory'),
  store('Store',
      'A retail location where inventory items are displayed and sold to customers'),
  shelf('Shelf',
      'A horizontal surface or rack within a store or warehouse used to store and organize items'),
  bin('Bin',
      'A specific compartment or container within a shelf or storage system used to store individual items'),
  aisle('Aisle',
      'A pathway or corridor within a warehouse or store that provides access to rows of shelving or bins'),
  rack('Rack',
      'A vertical structure with multiple shelves or levels used to store items efficiently in a warehouse'),
  pallet('Pallet',
      'A portable platform with both a top and bottom deck, used for stacking and transporting goods in a warehouse'),
  bay('Bay', 'A designated section of a rack or shelf where items are stored'),
  storageLocation('Storage Location',
      'A specific area or spot within a warehouse or store where items are kept'),
  bulkStorage('Bulk Storage',
      'A section of a warehouse reserved for the storage of larger quantities of items, typically not accessible for picking'),
  pickArea('Pick Area',
      'A designated location within a warehouse where items are stored for easy access and order picking'),
  receivingArea('Receiving Area',
      'The area within a warehouse or store where incoming shipments are processed and items are initially placed in inventory'),
  shippingArea('Shipping Area',
      'The area within a warehouse or store where outgoing shipments are prepared and loaded for transport'),
  coldStorage('Cold Storage',
      'Temperature-controlled storage areas used for items that require refrigeration or freezing'),
  stagingArea('Staging Area',
      'A temporary storage area where items are placed before being moved to their final storage location or prepared for shipping'),
  pickingZone('Picking Zone',
      'A designated area within a warehouse where order pickers gather items for customer orders'),
  rackingSystem('Racking System',
      'The overall structure of racks and shelves used for storage in a warehouse'),
  backroom('Backroom',
      'The storage area within a retail store where excess inventory is kept, away from the sales floor'),
  mezzanine('Mezzanine',
      'An intermediate floor within a warehouse used for additional storage space'),
  mobileShelving('Mobile Shelving',
      'Shelving units mounted on wheels or tracks to maximize space efficiency in a warehouse');

  final String label;
  final String description;

  const InventoryLocationType(this.label, this.description);
}

enum Perishability {
  durableGoods('Durable Goods',
      'Durable goods are products that have a long lifespan and are not typically considered perishable. They include items like appliances, furniture, electronics, and vehicles. These products are built to last for years or even decades.'),
  nonPerishableGoods('Non-Perishable Goods',
      'Non-perishable goods are items that have a long shelf life and do not spoil quickly. They can be stored for extended periods without significant degradation in quality. Examples include canned foods, dry grains, pasta, and non-perishable snacks.'),
  perishableGoods('Perishable Goods',
      'Perishable goods are items that have a short shelf life and can deteriorate quickly if not stored properly.');

  final String label;
  final String description;

  const Perishability(this.label, this.description);
}

enum CurrentInventoryFilter {
  all('All'),
  inStock('In Stock'),
  forReorder('For Reorder'),
  lowStock('Low Stock'),
  outOfStock('Out of Stock');

  final String label;

  const CurrentInventoryFilter(this.label);
}

enum IncomingInventoryFilter {
  all('All'),
  forPlacement('For Placement'),
  forConfirmation('For Confirmation'),
  forDelivery('For Delivery'),
  forInventory('For Inventory');

  final String label;

  const IncomingInventoryFilter(this.label);
}

enum ExpirationState {
  good('Good'),
  nearExpiration('Near Expiration'),
  expired('Expired');

  final String label;

  const ExpirationState(this.label);
}

enum AdjustmentType {
  stockLevelAdjustment('Stock Level Adjustment'),
  costPriceAdjustment('Cost Price Adjustment'),
  salePriceAdjustment('Sale Price Adjustment');

  final String label;

  const AdjustmentType(this.label);
}

/*enum ScanState {

}*/
