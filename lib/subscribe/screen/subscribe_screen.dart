import 'package:flutter/material.dart';

import '../widget/selection_list.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back)),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 200,
              color: Colors.blue,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Document Files Manager',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SelectionList(),
                    const SizedBox(
                      height: 20,
                    ),
                    FilledButton(
                        onPressed: () {}, child: const Text('SUBSCRIBE NOW'))
                  ],
                ),
              ),
            ),
            const Text(
              'Cancel anytime',
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Terms of service',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Text(
                    'Privacy policy',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Text(
                    'Restore Purchase',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
