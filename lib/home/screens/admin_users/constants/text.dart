// admin users table
import 'package:dart_hqs/hqs_user_service.pb.dart';

const adminUsersTableTitle = "Manage Users";
const adminUsersGenerateSignupLink = "Generate Signup Link";
const adminUsersCreateUserButton = "New User";
const adminUsersImageCol = "Image";
const adminUsersNameCol = "Name";
const adminUsersViewAccessCol = "View Access";
const adminUsersCreateAccessCol = "Create Access";
const adminUsersPermissionAccessCol = "Permission Access";
const adminUsersDeleteAccessCol = "Delete Access";
const adminUsersBlockAccessCol = "Block Access";
const adminUsersResetAccessCol = "Reset Access";
const adminUsersBlockedCol = "Blocked";
const adminUsersActionsCol = "Actions";

// generaet signup link dialog
const generateSignUpLinkTitle = "Generate Signup Link";
const generateSignUpLinkRules =
    "The system requires valid access codes. To grant create access, one has to to grant the user view and permission access as well. To grant delete, permission, reset or block access, one also has to grant the user view access.";
const generateSignUpLinkSelectViewTitle = "Select View Access";
const generateSignUpLinkSelectViewHint = "Select View Access";
const generateSignUpLinkSelectCreateTitle = "Select Create Access";
const generateSignUpLinkSelectCreateHint = "Select Create Access";
const generateSignupLinkSelectResetValidator = "Reset access requires view access";
const generateSignUpLinkSelectCreateValidator =
    "Create access requires view and permission access";
const generateSignUpLinkSelectPermissionTitle = "Select Permission Access";
const generateSignUpLinkSelectPermissionHint = "Select Permission Access";
const generateSignUpLinkSelectPermissionValidator =
    "Permission access also requires view access";
const generateSignUpLinkSelecDeleteTitle = "Select Delete Access";
const generateSignUpLinkSelectDeleteHint = "Select Delete Access";
const generateSignUpLinkSelectDeleteValidator =
    "Delete access also requires view access";
const generateSignUpLinkSelecBlockTitle = "Select Block Access";
const generateSignUpLinkSelectBlockeHint = "Select Block Access";
const generateSignUpLinkSelectBlockValidator =
    "Block access also requires view access";
const generateSignUpLinkSelecResetTitle = "Select Reset Access";
const generateSignUpLinkSelectResetHint = "Select Reset Access";
const generateSignUpLinkCopyTokenSuccessTitle = "Token Copied";
const generateSignUpLinkCopyTokenSuccessText =
    "Token has been copied. Send it to a new team member so he can signup!";
const copyTokenButtonNotGenerated = "Token not generated yet";
const generateSignUpLinkCloseButton = "Close";
const generateSignUpLinkGenerateButton = "Generate";

// create user dialog
const creatUserDialogTitle = "Create User";
const createUserPermissionkRules = generateSignUpLinkRules;
const createUserNameText = "Name";
const createUserNameHint = "Name";
const createUserNameValidator = "Please enter a valid name";
const createUserEmailText = "Email";
const createUserEmailHint = "Email";
const createUserEmailValidator = "Please enter a valid email";
const createUserPasswordText = "Password";
const createUserPasswordHint = "Password";
const createUserPasswordlValidator = "Please enter a valid password";
const createUserSelectResetValidator = "Reset access requires view access";
const createUserSelectViewTitle = "Select View Access";
const createUserSelectViewHint = "Select View Access";
const createUserSelectCreateTitle = "Select Create Access";
const createUserSelectCreateHint = "Select Create Access";
const createUserSelectResetTitle = "Select Reset Access";
const createUserSelectResetHint = "Select Reset Access";
const createUserSelectCreateValidator =
    "Create access requires permission and view access";
const createUserSelectPermissionTitle = "Select Permission Access";
const createUserSelectPermissionHint = "Select Permission Access";
const createUserSelectPermissionValidator =
    "Permission access also requires view access";
const createUserSelectDeleteTitle = "Select Delete Access";
const createUserSelectDeleteHint = "Select Delete Access";
const createUserSelectDeleteValidator =
    "Delete access also requires view access";
const createUserSelectBlockTitle = "Select Block Access";
const createUserSelectBlockHint = "Select Block Access";
const createUserSelectBlockValidator = "Block access also requires view access";
const createUserSelectGenderTitle = "Select Gender";
const createUserSelectGenderHint = "Select Gender";
const createUserDialogCloseButtonText = "Close";
const createUserDialogCreateButtonText = "Create";
const createUserDialogExceptionTitle = "Something went wrong";
const createUserDialogExceptionText =
    "Could not create user. Please check that you have a valid wifi connection.";
const createUserDialogSuccessTitle = "User successfully created!";
const createUserDialogSuccessText = "The user has successfully been created.";

// user source
const userSourceActionBlockValue = "block";
const userSourceActionBlockText = "Block / Unblock";
const userSourceActionViewValue = "view";
const userSourceActionViewText = "View Profile";
const userSourceActionEditValue = "edit";
const userSourceActionEditText = "Edit Permissions";
const userSourceActionResetValue = "reset";
const userSourceActionResetText = "Email Reset Password Link";
const userSourceActionDeleteValue = "delete";
const userSourceActionDeleteText = "Delete";
const userSourceActionNotAllowed = "Not allowed";
// user source delete user dialog
String userSourceDeleteUserDialogTitle(User user) =>
    "Are you sure you want to delete ${user.name} ?";
const userSourceDeleteUserDialogTextOne =
    "Deleting a user is a NON-reversible action. This means that you will";
const userSourceDeleteUserDialogTextTwo =
    "not be able to get that users information back.";
const userSourceDeleteUserDialogCloseBtnText = "Cancel";
const userSourceDeleteUserDialogDeleteBtnText = "Delete";
const userSourceDeleteExceptionTitle = "Something went wrong";
String userSourceDeleteExceptionText(User user) =>
    "We could not delete ${user.name}. Please make sure that you have a valid wifi connection.";
String userSourceDeleteSuccessTitle(User user) =>
    "${user.name} was successfully deleted";
String userSourceDeleteSuccessText(User user) =>
    "We have successfully deleted ${user.name}.";
// user source block user dialog
String userSourceBlockDialogTitle(User user) =>
    "Are you sure you want to " +
    (user.blocked ? "unblock " : "block ") +
    "${user.name}?";
const userSourceBlockDialogTextOne =
    "When blocking a user, that user will NOT be able to";
const userSourceBlockDialogTextTwo =
    "access anything in the system - not even his/her own account.";
const userSourceBlockDialogTextThree =
    "You can always unblock a user after blocking him/her.";
const userSourceBlockDialogCancelBtnText = "Cancel";
String userSourceBlockDialogBlockBtnText(User user) =>
    user.blocked ? "Unblock" : "Block";
const userSourceBlockDialogExceptionTitle = "Something went wrong";
String userSourceBlockDialogExceptionText(User user, Error error) =>
    "We could " +
    (user.blocked ? "unblock" : "block") +
    " ${user.name}. Please make sure that you have a valid wifi connection. The error printed was: ${error.toString()}";
String userSourceBlockDialogSuccessTitle(User user) =>
    "${user.name} was successfully " + (user.blocked ? "unblocked" : "blocked");
String userSourceBlockDialogSuccessText(User user) =>
    "We have successfully" +
    (user.blocked ? "unblocked" : "blocked") +
    " ${user.name}.";
// user source reset password dialog
String userSourceResetPasswordDialogTitle(User user) =>
    "Send reset password email to " + "${user.name}?";
String userSourceResetPasswordDialogTextOne(User user) =>
    "This action sends an email to ${user.email} with a reset password";
String userSourceResetPasswordDialogTextTwo(User user) =>
    "link that ${user.gender ? 'she' : 'he'} can use to reset ${user.gender ? 'hers' : 'his'} password with.  The link is valid for 24";
const userSourceResetPasswordDialogTextThree =
    "hours and can only be used once.";
const userSourceResetPasswordDialogCancelBtnText = "Cancel";
const userSourceResetPasswordDialogBlockBtnText = "Send";
const userSourceResetPasswordDialogExceptionTitle = "Something went wrong";
String userSourceResetPasswordDialogExceptionText(User user, Error error) =>
    "We could send reset password email to ${user.email} wit error: ${error.toString()}";
const userSourceResetPassworDialogSuccessTitle =
    "Successfully sent reset password email ";
String userSourceResetPasswordDialogSuccessText(User user) =>
    "We have successfully sent the reset password email to ${user.email}";
// user source edit user dialog
String userSourceEditDialogTitle(User user) =>
    "Edit ${user.name}'s Permissions";
const userSourceEditDialogPermissionRuleText = generateSignUpLinkRules;
const editUserSelectResetValidator = "Reset access requires view access";
const userSourceEditDialogViewAccessText = "View Access";
const userSourceEditDialogViewAccessHint = "View Access";
const userSourceEditDialogCreateAccessText = "Create Access";
const userSourceEditDialogCreateAccessHint = "Create Access";
const userSourceEditDialogCreateAccessValidator =
    "Create access requires view and permission access";
const userSourceEditDialogPermissionAccessText = "Permission Access";
const userSourceEditDialogPermissionAccessHint = "Permission Access";
const userSourceEditDialogPermissionAccessValidator =
    "Permission access requires view access";
const userSourceEditDialogDeleteAccessText = "Delete Access";
const userSourceEditDialogDeleteAccessHint = "Delete Access";
const userSourceEditDialogDeleteAccessValidator =
    "Delete access requires view access";
const userSourceEditDialogBlockAccessText = "Block Access";
const userSourceEditDialogBlockAccessHint = "Block Access";
const userSourceEditDialogResetAccessText = "Reset Access";
const userSourceEditDialogResetAccessHint = "Reset Access";
const userSourceEditDialogBlockAccessValidator =
    "Block access requires view access";
const userSourceEditDialogCloseBtnText = "Close";
const userSourceEditDialogUpdateBtnText = "Update";
const userSourceEditDialogExceptionTitle = "Something went wrong";
String userSourceEditDialogExceptionText(User user) =>
    "Could not update the allowances of ${user.name}";
const userSourceEditDialogSuccessTitle = "Successfully updated allowances";
String userSourceEditDialogSuccessText(User user) =>
    "Successfully updated the allowances of ${user.name}";
