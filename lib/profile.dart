import 'package:accustox/controllers.dart';

import 'models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'widget_components.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userProfileData = ref.watch(userProfileProvider);

    return userProfileData.when(
        data: (data) => ProfileBody(userProfile: data),
        error: (e, st) =>
            const ErrorMessage(errorMessage: 'Something went wrong...'),
        loading: () => const LoadingWidget());
  }
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key, required this.userProfile});

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(0.0),
              borderOnForeground: true,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 16.0,
                        runSpacing: 4.0,
                        children: [
                          InformationWithLabel(
                              label: 'Business Name',
                              data: userProfile.businessName),
                          InformationWithLabel(
                              label: 'Owner', data: userProfile.ownerName),
                          InformationWithLabel(
                              label: 'Email', data: userProfile.email),
                          InformationWithLabel(
                              label: 'Contact Number',
                              data: userProfile.contactNumber),
                          InformationWithLabel(
                              label: 'Address', data: userProfile.address)
                        ],
                      ),
                    ),
                    TextButton(
                        onPressed: () =>
                            navigationController.navigateToEditProfile(),
                        child: const Icon(Icons.edit_outlined))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
