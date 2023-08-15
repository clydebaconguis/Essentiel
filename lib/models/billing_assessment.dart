class BillingAssessmentInfo {
  final String particulars;
  final String amount;
  final String balance;
  final String duedate;

  BillingAssessmentInfo({
    required this.particulars,
    required this.amount,
    required this.balance,
    required this.duedate,
  });

  factory BillingAssessmentInfo.fromJson(Map json) {
    var particulars = json['particulars'] ?? '';
    var amount = json['amount'] ?? '';
    var balance = json['balance'] ?? '';
    var duedate = json['duedate'] ?? '';
    return BillingAssessmentInfo(
        particulars: particulars,
        amount: amount,
        duedate: duedate,
        balance: balance);
  }
}
