import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_account.freezed.dart';
part 'user_account.g.dart';

@Freezed()
@JsonSerializable()
class UserAccount with _$UserAccount {
  @override
  final String id;
  @override
  final String name;

  const UserAccount({required this.id, required this.name});

  factory UserAccount.fromJson(Map<String, dynamic> json) =>
      _$UserAccountFromJson(json);

  Map<String, Object?> toJson() => _$UserAccountToJson(this);
}
