import 'package:flutter/material.dart';
import 'package:you_c/models/contract.dart';
import 'package:you_c/utils.dart';

/// Used to display a [Contract]
class ContractCard extends StatelessWidget {
  final Contract contract;

  final void Function(Contract c) onDelete;
  final void Function(Contract c) onFulfill;
  final void Function(Contract c) onFail;

  const ContractCard({
    super.key,
    required this.contract,
    required this.onDelete,
    required this.onFulfill,
    required this.onFail,
  });

  @override
  Widget build(BuildContext context) {
    final actionRow = Container(
      decoration: const BoxDecoration(
        color: Color(0x6E676767),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => onFail(contract),
                icon: Icon(
                  Icons.close,
                  color: !contract.fulfilled ? Colors.red : null,
                )),
            IconButton(
              onPressed: () => onDelete(contract),
              icon: const Icon(
                Icons.delete_forever,
                size: 35,
              ),
              color: const Color(0x78393939),
              hoverColor: Colors.red,
            ),
            IconButton(
                onPressed: () => onFulfill(contract),
                icon: Icon(
                  Icons.check,
                  color: contract.fulfilled ? Colors.green : null,
                ))
          ],
        ),
      ),
    );

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //
        mainAxisSize: MainAxisSize.max,
        //
        children: [
          ...[
            Text(
              contract.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(contract.content, softWrap: true),
          ].padded(const EdgeInsets.all(8)),
          actionRow,
        ],
      ),
    );
  }
}
