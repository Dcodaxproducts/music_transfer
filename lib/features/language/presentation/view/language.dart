import 'package:pixart_app/features/ads/presentation/controller/ads_controller.dart';
import '../../../../imports.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('language'.tr),
        backgroundColor: Colors.transparent,
      ),
      body: GetBuilder<LocalizationController>(
        builder: (con) {
          return Padding(
            padding: AppPadding.padding16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(borderRadius: AppRadius.circular16),
                  child: CustomTextField(
                    hintText: 'search_langauge'.tr,
                    suffixIcon: Iconsax.search_normal,
                    onChanged: con.searchLanguage,
                    filled: false,
                  ),
                ),
                SizedBox(height: 16.sp),
                Expanded(
                  child: ListView.separated(
                    itemCount: con.languages.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      LanguageModel language = con.languages[index];
                      bool selected = con.selectedIndex == index;

                      return InkWell(
                        onTap: () {
                          con.setSelectIndex(index);
                          LocalizationController.to.setLanguage(
                            Locale(language.languageCode, language.countryCode),
                          );
                        },
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.sp),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18.sp,
                                backgroundImage: AssetImage(
                                  'assets/images/${language.countryCode.toLowerCase()}.png',
                                ),
                              ),
                              SizedBox(width: 12.sp),
                              Expanded(child: Text(language.languageName)),
                              LanguageRadioButton(selected: selected),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                AdsController.find.buildLanguageScreenAd(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: AppPadding.padding16.copyWith(top: 0),
        child: PrimaryButton(text: 'done'.tr, onPressed: pop),
      ),
    );
  }
}

class LanguageRadioButton extends StatelessWidget {
  final bool selected;
  const LanguageRadioButton({super.key, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 20.sp,
      width: 20.sp,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? primaryColor : Theme.of(context).dividerColor,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 12.sp,
          width: 12.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: selected ? secondaryGradient : null,
          ),
        ),
      ),
    );
  }
}
