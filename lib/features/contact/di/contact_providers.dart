import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pulse_chat/core/network/api_client.dart';
import 'package:pulse_chat/core/network/local_auth_source.dart';
import 'package:pulse_chat/features/contact/data/repositories/contact_repository_impl.dart';
import 'package:pulse_chat/features/contact/data/source/network/contact_service.dart';
import 'package:pulse_chat/features/contact/domain/repositories/contact_repository.dart';
import 'package:pulse_chat/features/contact/domain/usecase/create_contact.dart';
import 'package:pulse_chat/features/contact/domain/usecase/delete_contact.dart';
import 'package:pulse_chat/features/contact/domain/usecase/get_contacts_list.dart';
import 'package:pulse_chat/features/contact/domain/usecase/update_contact.dart';
import 'package:pulse_chat/features/contact/presentation/contacts_page/change_notifier/contacts_notifier.dart';
import 'package:pulse_chat/features/contact/presentation/sent_requests_page/change_notifier/sent_request_notifier.dart';

List<SingleChildWidget> contactProviders = [
  // SOURCES AND SERVICE
  Provider<ContactService>(
    create: (context) => context.read<ApiClient>().contactApi,
  ),

  // REPOSITORIES
  Provider<ContactRepository>(
    create:
        (context) => ContactRepositoryImpl(
          localAuthSource: context.read<LocalAuthSource>(),
          contactService: context.read<ContactService>(),
        ),
  ),
  // USE CASE
  Provider<GetUserContacts>(
    create: (context) => GetUserContacts(context.read<ContactRepository>()),
  ),
  Provider<GetUserPendingRequests>(
    create:
        (context) => GetUserPendingRequests(context.read<ContactRepository>()),
  ),
  Provider<GetUserSentRequests>(
    create: (context) => GetUserSentRequests(context.read<ContactRepository>()),
  ),
  Provider<SendFriendRequest>(
    create: (context) => SendFriendRequest(context.read<ContactRepository>()),
  ),
  Provider<AcceptFriendRequest>(
    create: (context) => AcceptFriendRequest(context.read<ContactRepository>()),
  ),
  Provider<DeleteContact>(
    create: (context) => DeleteContact(context.read<ContactRepository>()),
  ),

  // NOTIFIER--------------------------------------------------------------------------------------
  ChangeNotifierProvider<ContactsNotifier>(
    create:
        (context) => ContactsNotifier(
          getUserContacts: context.read<GetUserContacts>(),
          getUserPendingRequests: context.read<GetUserPendingRequests>(),
          acceptContact: context.read<AcceptFriendRequest>(),
          deleteContact: context.read<DeleteContact>(),
        ),
  ),
  ChangeNotifierProvider<SentRequestsNotifier>(
    create:
        (context) => SentRequestsNotifier(
          getUserSentRequests: context.read<GetUserSentRequests>(),
          deleteContact: context.read<DeleteContact>(),
        ),
  ),
];
