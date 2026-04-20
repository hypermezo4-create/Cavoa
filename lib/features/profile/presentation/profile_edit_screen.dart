import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_profile.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../data/profile_controller.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();
  final _ageController = TextEditingController();

  String _gender = 'male';
  bool _visitedBefore = false;
  String? _avatarPath;
  bool _saving = false;

  String get _localeCode => Localizations.localeOf(context).languageCode;

  String _tx({
    required String en,
    required String ar,
    required String de,
    required String ru,
  }) {
    switch (_localeCode) {
      case 'ar':
        return ar;
      case 'de':
        return de;
      case 'ru':
        return ru;
      default:
        return en;
    }
  }

  @override
  void initState() {
    super.initState();
    final profile = ProfileController.instance.value;
    if (profile != null) {
      _apply(profile);
    }
  }

  void _apply(CavoUserProfile profile) {
    _nameController.text = profile.fullName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _cityController.text = profile.city;
    _areaController.text = profile.area;
    _addressController.text = profile.addressLine;
    _bioController.text = profile.bio;
    _ageController.text = profile.age?.toString() ?? '';
    _gender = profile.gender;
    _visitedBefore = profile.visitedBefore;
    _avatarPath = profile.avatarPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 85, maxWidth: 1400);
    if (file == null || !mounted) return;
    setState(() => _avatarPath = file.path);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final current = ProfileController.instance.value ?? CavoUserProfile.empty();
    final updated = current.copyWith(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      city: _cityController.text.trim(),
      area: _areaController.text.trim(),
      addressLine: _addressController.text.trim(),
      bio: _bioController.text.trim().isEmpty
          ? _tx(
              en: 'Premium CAVO member',
              ar: 'عضو CAVO بريميوم',
              de: 'Premium-CAVO-Mitglied',
              ru: 'Премиум-участник CAVO',
            )
          : _bioController.text.trim(),
      age: int.tryParse(_ageController.text.trim()),
      gender: _gender,
      visitedBefore: _visitedBefore,
      avatarPath: _avatarPath,
    );
    setState(() => _saving = true);
    await ProfileController.instance.saveProfile(updated);
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  children: [
                    CavoCircleIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      isLight: isLight,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _tx(
                              en: 'Edit Profile',
                              ar: 'تعديل الملف الشخصي',
                              de: 'Profil bearbeiten',
                              ru: 'Редактировать профиль',
                            ),
                            style: TextStyle(color: primary, fontSize: 28, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _tx(
                              en: 'Complete your real CAVO account details.',
                              ar: 'أكمل بيانات حسابك الحقيقي في CAVO.',
                              de: 'Vervollständige deine echten CAVO-Kontodaten.',
                              ru: 'Заполните реальные данные вашего аккаунта CAVO.',
                            ),
                            style: TextStyle(color: secondary, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                CavoGlassCard(
                  isLight: isLight,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _pick(ImageSource.gallery),
                            child: CircleAvatar(
                              radius: 42,
                              backgroundColor: CavoColors.gold.withValues(alpha: 0.14),
                              backgroundImage: _avatarPath == null ? null : FileImage(File(_avatarPath!)),
                              child: _avatarPath == null ? const Icon(Icons.person_rounded, color: CavoColors.gold, size: 34) : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _tx(
                                    en: 'Profile photo',
                                    ar: 'صورة الملف الشخصي',
                                    de: 'Profilfoto',
                                    ru: 'Фото профиля',
                                  ),
                                  style: TextStyle(color: primary, fontWeight: FontWeight.w900, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => _pick(ImageSource.gallery),
                                        child: Text(
                                          _tx(
                                            en: 'Gallery',
                                            ar: 'المعرض',
                                            de: 'Galerie',
                                            ru: 'Галерея',
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => _pick(ImageSource.camera),
                                        child: Text(
                                          _tx(
                                            en: 'Camera',
                                            ar: 'الكاميرا',
                                            de: 'Kamera',
                                            ru: 'Камера',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _Field(
                        controller: _nameController,
                        label: context.l10n.fullName,
                        requiredMessage: _tx(
                          en: 'Please enter your name',
                          ar: 'من فضلك أدخل اسمك.',
                          de: 'Bitte gib deinen Namen ein.',
                          ru: 'Пожалуйста, введите ваше имя.',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _Field(controller: _emailController, label: context.l10n.emailAddress, readOnly: true),
                      const SizedBox(height: 12),
                      _Field(
                        controller: _phoneController,
                        label: context.l10n.phoneNumber,
                      ),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: _Field(
                            controller: _cityController,
                            label: context.l10n.cityLabel,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _Field(
                            controller: _areaController,
                            label: context.l10n.areaLabel,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      _Field(
                        controller: _addressController,
                        label: _tx(
                          en: 'Address details',
                          ar: 'تفاصيل العنوان',
                          de: 'Adressdetails',
                          ru: 'Детали адреса',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _gender,
                            dropdownColor: isLight ? Colors.white : const Color(0xFF151515),
                            decoration: _decoration(
                              _tx(en: 'Gender', ar: 'النوع', de: 'Geschlecht', ru: 'Пол'),
                              isLight,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'male',
                                child: Text(_tx(en: 'Male', ar: 'ذكر', de: 'Männlich', ru: 'Мужской')),
                              ),
                              DropdownMenuItem(
                                value: 'female',
                                child: Text(_tx(en: 'Female', ar: 'أنثى', de: 'Weiblich', ru: 'Женский')),
                              ),
                            ],
                            onChanged: (value) => setState(() => _gender = value ?? 'male'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _Field(
                            controller: _ageController,
                            label: _tx(en: 'Age', ar: 'العمر', de: 'Alter', ru: 'Возраст'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      SwitchListTile.adaptive(
                        value: _visitedBefore,
                        activeColor: CavoColors.gold,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          _tx(
                            en: 'Visited CAVO before?',
                            ar: 'زرت CAVO من قبل؟',
                            de: 'Schon einmal CAVO besucht?',
                            ru: 'Вы уже посещали CAVO?',
                          ),
                          style: TextStyle(color: primary, fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          _tx(
                            en: 'Tell us if you have visited a branch before.',
                            ar: 'أخبرنا إن كنت قد زرت أحد الفروع من قبل.',
                            de: 'Sag uns, ob du schon einmal eine Filiale besucht hast.',
                            ru: 'Подскажите, посещали ли вы раньше филиал.',
                          ),
                          style: TextStyle(color: secondary, fontSize: 12),
                        ),
                        onChanged: (value) => setState(() => _visitedBefore = value),
                      ),
                      const SizedBox(height: 8),
                      _Field(
                        controller: _bioController,
                        label: _tx(en: 'Bio', ar: 'نبذة', de: 'Info', ru: 'О себе'),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _saving ? null : () => Navigator.of(context).maybePop(),
                child: Text(context.l10n.cancel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: Text(
                  _saving
                      ? _tx(
                          en: 'Saving...',
                          ar: 'جارٍ الحفظ...',
                          de: 'Wird gespeichert...',
                          ru: 'Сохранение...',
                        )
                      : _tx(
                          en: 'Save Changes',
                          ar: 'حفظ التغييرات',
                          de: 'Änderungen speichern',
                          ru: 'Сохранить изменения',
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _decoration(String label, bool isLight) {
    final fill = isLight ? Colors.white : const Color(0xFF141416);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: BorderSide(color: CavoColors.gold.withValues(alpha: 0.14)),
    );
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: fill,
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: CavoColors.gold, width: 1.2),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.requiredMessage,
  });

  final TextEditingController controller;
  final String label;
  final bool readOnly;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? requiredMessage;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (readOnly) return null;
        if (requiredMessage != null && (value == null || value.trim().isEmpty)) {
          return requiredMessage;
        }
        return null;
      },
      style: TextStyle(color: isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: isLight ? Colors.white : const Color(0xFF141416),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide(color: CavoColors.gold.withValues(alpha: 0.14))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide(color: CavoColors.gold.withValues(alpha: 0.14))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: const BorderSide(color: CavoColors.gold, width: 1.2)),
      ),
    );
  }
}
