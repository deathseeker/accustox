import 'models.dart';

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
  inStock,
  lowStock,
  outOfStock,
}

enum IncomingInventoryState {
  forPlacement,
  forConfirmation,
  forDelivery,
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
  net30('Net 30', 'Payment is due 30 days from the date of the invoice.'),
  net60('Net 60', 'Payment is due 60 days from the date of the invoice.'),
  net90('Net 90', 'Payment is due 90 days from the date of the invoice.'),
  dueOnReceipt('Due on Receipt',
      'Payment is due immediately upon receipt of the invoice.'),
  cashOnDelivery('Cash on Delivery',
      'Payment is made at the time of delivery of goods or services.'),
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
