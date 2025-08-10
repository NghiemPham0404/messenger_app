import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pulse_chat/features/contact/domain/usecase/create_contact.dart';
import 'package:pulse_chat/features/contact/domain/usecase/delete_contact.dart';
import 'package:pulse_chat/features/contact/domain/usecase/update_contact.dart';
import 'package:pulse_chat/features/group/domain/usecase/group/search_groups.dart';
import 'package:pulse_chat/features/search/presentation/search_page/change_notifier/search_notifier.dart';
import 'package:pulse_chat/features/user/domain/usecase/search_users.dart';

List<SingleChildWidget> searchProviders = [
  //NOTIFIER--------------------------------------------------------------------------
  ChangeNotifierProvider<SearchNotifier>(
    create:
        (context) => SearchNotifier(
          searchUsers: context.read<SearchUsers>(),
          searchGroups: context.read<SearchGroups>(),
          sendFriendRequest: context.read<SendFriendRequest>(),
          acceptFriendRequest: context.read<AcceptFriendRequest>(),
          dismissFriendRequest: context.read<DeleteContact>(),
        ),
  ),
];
