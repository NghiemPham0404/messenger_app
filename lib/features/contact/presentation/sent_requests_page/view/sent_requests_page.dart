import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_chat/features/contact/presentation/components/contact_item.dart';
import 'package:pulse_chat/features/contact/presentation/sent_requests_page/change_notifier/sent_request_notifier.dart';

class SentRequestsPage extends StatefulWidget {
  const SentRequestsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SentRequestsPageState();
  }
}

class SentRequestsPageState extends State<SentRequestsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sentRequestsNotifier = Provider.of<SentRequestsNotifier>(
        context,
        listen: false,
      );
      sentRequestsNotifier.getSentRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SentRequestsNotifier>(
      builder:
          (context, sentRequestsNotifier, child) => SafeArea(
            child:
                sentRequestsNotifier.isLoading
                    ? Scaffold(body: Center(child: CircularProgressIndicator()))
                    : buildBody(sentRequestsNotifier),
          ),
    );
  }

  Widget buildBody(SentRequestsNotifier sentRequestsNotifier) {
    final sentRequestList = sentRequestsNotifier.sentRequestList?.results ?? [];
    return CupertinoPageScaffold(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            sentRequestsNotifier.getSentRequests();
          },
          child: ListView.builder(
            itemCount: sentRequestList.length,
            itemBuilder:
                (context, index) => SentRequestItem(
                  contact: sentRequestList[index],
                  cancel: (id) => sentRequestsNotifier.cancelRequest(id),
                ),
          ),
        ),
      ),
    );
  }
}
