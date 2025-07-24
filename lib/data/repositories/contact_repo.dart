import 'dart:async';

import 'package:chatting_app/data/models/contact.dart';
import 'package:chatting_app/data/models/group.dart';
import 'package:chatting_app/data/network/api_client.dart';
import 'package:chatting_app/data/responses/list_response.dart';
import 'package:chatting_app/data/responses/message_response.dart';
import 'package:chatting_app/data/responses/object_response.dart';
import 'package:flutter/cupertino.dart';

enum ContactType { accept, pending, request }

enum UpdateContactAction { block, accept }

class ContactRepo {
  final _apiClient = ApiClient();

  ContactRepo._internal();

  static final ContactRepo _instance = ContactRepo._internal();

  factory ContactRepo() => _instance;

  Future<ListResponse<Contact>> fetchFriendList() async {
    return await _apiClient.contactApi.fetchContacts(ContactType.accept.name);
  }

  Future<ListResponse<Contact>> fetchPendingRequests() async {
    return await _apiClient.contactApi.fetchContacts(ContactType.pending.name);
  }

  Future<ListResponse<Contact>> fetchSentRequests() async {
    return await _apiClient.contactApi.fetchContacts(ContactType.request.name);
  }

  Future<ListResponse<Group>> fetchGroupRequests(
    int userId, {
    int page = 1,
  }) async {
    return await _apiClient.contactApi.fetchUserGroup(userId, page);
  }

  Future<ObjectResponse<Contact>> sendContactRequest(
    int userId,
    int contactUserId,
  ) async {
    final contactCreate = ContactCreate(
      userId: userId,
      contactUserId: contactUserId,
      status: 0,
    );
    debugPrint(contactCreate.toJson().toString());
    return await _apiClient.contactApi.createCotacts(contactCreate);
  }

  Future<ObjectResponse<Contact>> blockContactRequest(
    int userId,
    int contactUserId,
  ) async {
    final contactCreate = ContactCreate(
      userId: userId,
      contactUserId: contactUserId,
      status: 2,
    );
    return await _apiClient.contactApi.createCotacts(contactCreate);
  }

  Future<ObjectResponse<Contact>> acceptContact(int contactId) async {
    return await _apiClient.contactApi.updateContacts(contactId, {
      'action': UpdateContactAction.accept.name,
    });
  }

  Future<ObjectResponse<Contact>> blockContact(int contactId) async {
    return await _apiClient.contactApi.updateContacts(contactId, {
      'action': UpdateContactAction.block.name,
    });
  }

  Future<MessageResponse> deleteContact(int contactId) async {
    return await _apiClient.contactApi.delete(contactId);
  }
}
