import "package:app/data/models/social_income_payment.dart";
import "package:app/ui/configs/configs.dart";
import "package:app/view/widgets/income/review_payment_modal.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

String format = ",###,###";
NumberFormat f = NumberFormat(format, "en_US");

class PaymentCard extends StatelessWidget {
  final SocialIncomePayment payment;

  const PaymentCard({
    required this.payment,
    super.key,
  });

  String cleanStatus(PaymentStatus? currentStatus) {
    return currentStatus != null &&
            [PaymentStatus.confirmed, PaymentStatus.contested]
                .contains(currentStatus)
        ? currentStatus.name
        : "please review this payment";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: AppSpacings.h8,
                  child: Text(
                    "${payment.currency} ${f.format(payment.amount)}",
                    textScaleFactor: 1.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Text(getPaymentStatusText()),
                ),
                if (payment.status == PaymentStatus.contested)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "We will reach out to you soon",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
              ],
            ),
          ),
          if (payment.status != PaymentStatus.confirmed)
            Padding(
              padding: AppSpacings.a16,
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(60, 50)),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => ReviewPaymentModal(payment),
                  );
                },
                child: const Text("Review"),
              ),
            )
        ],
      ),
    );
  }

  String getPaymentStatusText() {
    return cleanStatus(payment.status);
  }
}
