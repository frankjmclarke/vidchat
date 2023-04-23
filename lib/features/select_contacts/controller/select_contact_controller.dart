import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vidchat/features/select_contacts/repository/select_contact_repository.dart';

// that retrieves contacts by calling the getContacts() method of the
// selectContactRepository class. The result of this provider is a Future that
// contains the contacts.
final getContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactRepository.getContacts();
});
//can be used to obtain an instance of the SelectContactController class in
//other parts of the code, and use it to call the selectContact method.
final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return SelectContactController(
    ref: ref,
    selectContactRepository: selectContactRepository,
  );
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;
  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  void selectContact(Contact selectedContact, BuildContext context) {
    //This method is used to select a contact and perform some action, which is
    //defined in the selectContactRepository class.
    selectContactRepository.selectContact(selectedContact, context);
  }
}
