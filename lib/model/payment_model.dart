class PaymentModel {
  final int? statusCode;
  final String? message;
  final Pagination? pagination;
  final PaymentData? paymentData;

  PaymentModel(
      {this.statusCode, this.message, this.pagination, this.paymentData});

  PaymentModel.fromJson(Map<String, dynamic> json)
      : statusCode = json["status_code"] as int?,
        message = json["message"] as String?,
        pagination = Pagination.fromJson(json["pagination"]),
        paymentData = PaymentData.fromMap(json["data"]);
}

class Pagination {
  final int? totalItems;
  final dynamic totalPages;
  final int? currentPage;

  Pagination({
    this.totalItems,
    this.totalPages,
    this.currentPage,
  });

  Pagination.fromJson(Map<String, dynamic> json)
      : totalItems = json['total_items'] as int?,
        totalPages = json['total_pages'],
        currentPage = json['current_page'] as int?;

  Map<String, dynamic> toJson() => {
        'total_items': totalItems,
        'total_pages': totalPages,
        'current_page': currentPage
      };
}

class PaymentData {
  final double? agentPayable;
  final double? agentPayment;
  final double? agentCustomerPayment;
  final List<GLEntries>? glEntries;

  PaymentData(
      {this.agentPayable,
      this.agentPayment,
      this.agentCustomerPayment,
      this.glEntries});

  PaymentData.fromMap(Map<String, dynamic> json)
      : agentPayable = json["agent_payable"] as double?,
        agentPayment = json["agent_payment"] as double?,
        agentCustomerPayment = json["agent_customer_payment"] as double?,
        glEntries = (json['gl_entries'] as List?)
            ?.map((dynamic e) => GLEntries.fromMap(e as Map<String, dynamic>))
            .toList();
}

class GLEntries {
  final String? referenceNo;
  final String? voucherNo;
  final String? postingDate;
  final String? postingTime;
  final String? partyName;
  final String? againstParty;
  final double? debit;
  final double? credit;
  final String? typeOfTransiction;

  GLEntries(
      {this.referenceNo,
      this.voucherNo,
      this.postingDate,
      this.postingTime,
      this.partyName,
      this.againstParty,
      this.debit,
      this.credit,
      this.typeOfTransiction});
  GLEntries.fromMap(Map<String, dynamic> json)
      : referenceNo = json["reference_no"] as String?,
        voucherNo = json["voucher_no"] as String?,
        postingDate = json["posting_date"] as String?,
        postingTime = json["posting_time"] as String?,
        partyName = json["party_name"] as String?,
        againstParty = json["against_party"] as String?,
        debit = json["debit"] as double?,
        credit = json["credit"] as double?,
        typeOfTransiction = json["type_of_transaction"] as String?;
}
