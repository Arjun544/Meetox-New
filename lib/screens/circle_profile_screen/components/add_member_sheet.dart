import 'package:meetox/core/imports/core_imports.dart';
import 'package:meetox/core/imports/packages_imports.dart';
import 'package:meetox/widgets/close_button.dart';

import 'followers_view.dart';

class AddMemberSheet extends HookWidget {
  final String id;
  final int limit;
  final bool isPrivate;
  final ValueNotifier<int> members;

  const AddMemberSheet({super.key, 
    required this.id,
    required this.limit,
    required this.isPrivate,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.9,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add members ( ${members.value}/$limit )',
                style: context.theme.textTheme.labelLarge,
              ),
              CustomCloseButton(
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: FollowersView(
              id: id,
              members: members,
              isPrivate: isPrivate,
              limit: limit,
            ),
          ),
        ],
      ),
    );
  }
}
