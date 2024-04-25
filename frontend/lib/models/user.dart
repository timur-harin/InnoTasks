import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  // class UserBase(BaseModel):
    // email: str
//     password: str


// class UserChangePassword(BaseModel):
//     email: str
//     password: str
//     new_password: str


// class User(UserBase):
//     id: int
//     token: str
//     last_token_update: Optional[datetime] = None

  factory User({
    required String email,
    required String password,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.UserChangePassword({
    required String email,
    required String password,
    required String new_password,
  }) = _UserChangePassword;

}
  
  