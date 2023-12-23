import 'package:elderly_people/pages/AddAppliances.dart';
import 'package:elderly_people/pages/AddEmergencyContact.dart';
import 'package:elderly_people/pages/AddMedecinePage.dart';
import 'package:elderly_people/pages/AddShoppingItem.dart';
import 'package:elderly_people/pages/AddTaskPage.dart';
import 'package:elderly_people/pages/AddTimeRoutine.dart';
import 'package:elderly_people/pages/AddUserGuide.dart';
import 'package:elderly_people/pages/ChangePassword.dart';
import 'package:elderly_people/pages/ChangeUserDetails.dart';
import 'package:elderly_people/pages/EditAppliances.dart';
import 'package:elderly_people/pages/EditEmergencyContact.dart';
import 'package:elderly_people/pages/EditMedicationTime.dart';
import 'package:elderly_people/pages/EditMedicinePage.dart';
import 'package:elderly_people/pages/EditRoutine.dart';
import 'package:elderly_people/pages/GenerateMeet.dart';
import 'package:elderly_people/pages/Home.dart';
import 'package:elderly_people/pages/HomePage.dart';
import 'package:elderly_people/pages/ListAppliancePage.dart';
import 'package:elderly_people/pages/ListEmergencyContact.dart';
import 'package:elderly_people/pages/ListMedecinePage.dart';
import 'package:elderly_people/pages/ListPrescription.dart';
import 'package:elderly_people/pages/ListRoutines.dart';
import 'package:elderly_people/pages/ListUserGuide.dart';
import 'package:elderly_people/pages/MemoryGameScreen.dart';
import 'package:elderly_people/pages/MemoryGameScreen2.dart';
import 'package:elderly_people/pages/News.dart';
import 'package:elderly_people/pages/PrescriptionResultPage.dart';
import 'package:elderly_people/pages/QRCodeScanner.dart';
import 'package:elderly_people/pages/RegistrationPage.dart';
import 'package:elderly_people/pages/ResultScreen.dart';
import 'package:elderly_people/pages/SettingPage.dart';
import 'package:elderly_people/pages/UncompletedTask.dart';
import 'package:elderly_people/pages/UpdateTaskPage.dart';
import 'package:elderly_people/pages/article_details_page.dart';
import 'package:elderly_people/pages/login_page.dart';
import 'package:elderly_people/pages/predefinedItemList.dart';
import 'package:elderly_people/pages/shoppingCart.dart';
import 'package:elderly_people/pages/voice_assitant.dart';
import 'package:elderly_people/service/auth_page.dart';
import 'package:get/get.dart';

class Routes {
  static const addToDoItems = "";
  static const home = "/";
  static const homepage = "/HomePage";
  static const addTaskPage = "/addTaskPage";
  static const authPage = "/authPage";
  static const loginPage = "/login";
  static const registrationPage = "/registrationPage";
  static const updateTaskPage = "/updateTaskPage";
  static const addEmergencyContact = '/addEmergencycontact';
  static const addAppliances = "/addAppliances";
  static const addRoutines = "/addRoutines";
  static const addMedecine = "/addMedecine";
  static const setting = "/setting";
  static const shoppingCart = "/shoppingCart";
  static const addShoppingItem = "/addShoppingItem";
  static const uncompletedTask = "/uncompletedTask";
  static const changePassword = "/changePassword";
  static const changeUserDetails = "/changeUserDetails";
  static const listMedecine = "/ListMedecine";
  static const editMedecine = "/editMedecine";
  static const listAppliances = "/listAppliances";
  static const editAppliances = "/editApplicanes";
  static const listRoutines = "/listRoutines";
  static const listEmergencyContact = "/listEmergencyContact";
  static const editEmergencyContact = "/editEmergencyContact";
  static const voiceAssistant = '/voiceAssistant';
  static const editRoutine = '/editRoutine';
  static const generateMeet = '/generateMeet';
  static const listUserGuide = '/listUserGuide';
  static const addUserGuide = '/addUserGUide';
  static const memoryGame = '/memoeryGame';
  static const editMedicationTime = '/editMedicationTime';
  static const newsArticle = '/newsArticle';
  static const singleArticle = '/singleArticle';
  static const QRPage = '/QRpage';
  static const resultPage = '/ResultPage';
  static const predefinedItem = "/PredefinedItems";
  static const listPrescriptionPage = "/LsitPrescription";
  static const prescriptionResultPage = "/prescriptionResultPage";
  
  //static const addToDoItems = "";
  static final List<GetPage> pages = [
    GetPage(
        name: home,
        page: () {
          return Home();
        }),
    GetPage(name: homepage, page: () => const HomePage()),
    GetPage(name: addTaskPage, page: () => const AddTaskPage()),
    GetPage(name: authPage, page: () => AuthPage()),
    GetPage(name: loginPage, page: () => const login_page()),
    GetPage(name: registrationPage, page: () => RegistrationPage()),
    GetPage(name: updateTaskPage, page: () => const UpdateTaskPage()),
    GetPage(name: addEmergencyContact, page: () => const AddEmergencyContact()),
    GetPage(name: addAppliances, page: () => const AddAppliances()),
    GetPage(name: addRoutines, page: () => const AddTimeRoutine()),
    GetPage(name: addMedecine, page: () => const AddMedecinePage()),
    GetPage(name: setting, page: () => const SettingPage()),
    GetPage(name: shoppingCart, page: () => const ShoppingCart()),
    GetPage(name: addShoppingItem, page: () => const AddShoppingItem()),
    GetPage(name: uncompletedTask, page: () => const UncompletedTask()),
    GetPage(name: changePassword, page: () => ChangePassword()),
    GetPage(name: changeUserDetails, page: () => const ChangeUserDetails()),
    GetPage(name: listMedecine, page: () => const ListMedecinePage()),
    GetPage(name: editMedecine, page: () => const EditMedicinePage()),
    GetPage(name: listAppliances, page: () => const ListAppliancePage()),
    GetPage(name: editAppliances, page: () => const EditAppliancesPage()),
    GetPage(name: listRoutines, page: () => const ListRoutine()),
    GetPage(
        name: listEmergencyContact, page: () => const ListEmergencyContact()),
    GetPage(
        name: listEmergencyContact, page: () => const ListEmergencyContact()),
    GetPage(
        name: editEmergencyContact, page: () => const EditEmergencyContact()),
    GetPage(name: voiceAssistant, page: () => const voice_assistant()),
    GetPage(name: editRoutine, page: () => const EditRoutine()),
    GetPage(name: generateMeet, page: () => const GenerateMeet()),
    GetPage(name: listUserGuide, page: () => const ListUserGuide()),
    GetPage(name: addUserGuide, page: () => const AddUserGuide()),
    GetPage(name: memoryGame, page: () => MemoryGameScreen()),
    GetPage(name: editMedicationTime, page: () => const EditMedicationTime()),
    GetPage(name: newsArticle, page: () => const News()),
    GetPage(name: singleArticle, page: () => const ArticlePage()),
    GetPage(name: QRPage, page: () => const QRCodeScanner()),
    GetPage(name: resultPage, page: () => const ResultScreen()),
    GetPage(name: predefinedItem, page:()=> const PredefinedItemList()),
    GetPage(name: listPrescriptionPage, page:()=> const ListPrescription()),
    GetPage(name: prescriptionResultPage, page:()=> const PrescriptionResultPage())

  ];
}
