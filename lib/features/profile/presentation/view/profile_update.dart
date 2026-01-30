import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:pixart_app/imports.dart';
import '../controller/profile_controller.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _nameController = TextEditingController();

  // value notifiers
  final ValueNotifier<XFile?> _profileImage = ValueNotifier<XFile?>(null);

  void _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _profileImage.value = image;
    }
  }

  @override
  void initState() {
    _nameController.text = AuthController.find.user?.name ?? '';
    super.initState();
  }

  @override
  dispose() {
    _nameController.dispose();
    _profileImage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: PrimaryBackButton()),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          return AbsorbPointer(
            absorbing: controller.isLoading,
            child: Form(
              key: _formKey,
              child: ListView(
                padding: AppPadding.screenPadding,
                children: [
                  SizedBox(height: 16.sp),
                  ValueListenableBuilder<XFile?>(
                    valueListenable: _profileImage,
                    builder: (context, value, child) {
                      return Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: _pickProfileImage,
                              child: CircleAvatar(
                                radius: 60.sp,
                                backgroundColor: context.theme.dividerColor,
                                backgroundImage: value != null
                                    ? FileImage(File(value.path))
                                    : CachedNetworkImageProvider(AuthController.find.user?.photoUrl ?? ''),
                              ),
                            ),
                            if (value != null)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickProfileImage,
                                  child: CircleAvatar(
                                    radius: 18.sp,
                                    backgroundColor: context.theme.primaryColor,
                                    child: Icon(Iconsax.edit_2, size: 16.sp, color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 40.sp),
                  Text("name".tr, style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  CustomTextField(
                    hintText: "enter_your_name".tr,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Iconsax.user_copy,
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please_enter_your_name".tr;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: GetBuilder<ProfileController>(
          builder: (controller) {
            return Padding(
              padding: AppPadding.screenPadding,
              child: PrimaryButton(
                text: controller.isLoading ? "updating".tr : "update".tr,
                onPressed: _signup,
                isLoading: controller.isLoading,
              ),
            );
          },
        ),
      ),
    );
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      ProfileController.find
          .updateProfile(name: _nameController.text.trim(), image: _profileImage.value)
          .then((success) {
            if (success) {
              showToast("profile_updated_successfully".tr);
              Get.back();
            }
          });
    }
  }
}
