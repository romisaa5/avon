import 'package:cosmetics/core/ui/widgets/app_button.dart';
import 'package:cosmetics/core/ui/widgets/app_images.dart';
import 'package:cosmetics/core/logic/helpers/extensions.dart';
import 'package:cosmetics/core/logic/network/dio_helper.dart';
import 'package:cosmetics/core/ui/theme/app_colors/light_app_colors.dart';
import 'package:cosmetics/core/logic/helpers/common_imports.dart';
import 'package:cosmetics/views/home/edit_account.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<AccountView> {
  UserProfile? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await DioHelper.get("/api/Auth/profile");
      setState(() {
        userProfile = UserProfile.fromJson(response.data);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load profile")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());

    if (userProfile == null)
      return Scaffold(
        appBar: AppBar(
          backgroundColor: LightAppColors.background,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Center(child: Text("No profile data")),
      );

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: LightAppColors.primary800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.h),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: AppImages(
                  imagePath: userProfile!.profilePhotoUrl,
                  height: 120.h,
                  width: 120.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            12.h.ph,
            Text(
              userProfile!.username,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              userProfile!.role,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
            ),

            24.h.ph,
            _infoCard(Icons.email, "Email", userProfile!.email),
            _infoCard(Icons.phone, "Phone", userProfile!.phoneNumber),
            _infoCard(Icons.flag, "Country Code", userProfile!.countryCode),

            30.h.ph,
            AppButton(
              text: "Edit Profile",
              width: 200.w,
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileView(profile: userProfile!),
                  ),
                );
                if (updated != null) {
                  setState(() => userProfile = updated);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        leading: Icon(icon, color: LightAppColors.primary800),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}

class UserProfile {
  final int id;
  String username;
  String email;
  final String role;
  final String phoneNumber;
  final String countryCode;
  String profilePhotoUrl;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.phoneNumber,
    required this.countryCode,
    required this.profilePhotoUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      role: json["role"],
      phoneNumber: json["phoneNumber"],
      countryCode: json["countryCode"],
      profilePhotoUrl: json["profilePhotoUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "profilePhotoUrl": profilePhotoUrl,
    };
  }
}
