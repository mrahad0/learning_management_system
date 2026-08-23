import 'package:get/get.dart';
import '../../data/model/course_model.dart';
import '../../data/model/progress_model.dart';
import '../../data/repo/course_repo.dart';
import '../../data/repo/progress_repo.dart';
import '../../views/base/custom_snackbar.dart';

class StudentController extends GetxController implements GetxService {
  final CourseRepo courseRepo;
  final ProgressRepo progressRepo;

  StudentController({required this.courseRepo, required this.progressRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CourseModel>? _approvedCourses;
  List<CourseModel>? get approvedCourses => _approvedCourses;

  List<ProgressModel>? _myProgress;
  List<ProgressModel>? get myProgress => _myProgress;

  CourseDetailModel? _courseDetail;
  CourseDetailModel? get courseDetail => _courseDetail;

  List<CertificateModel>? _myCertificates;
  List<CertificateModel>? get myCertificates => _myCertificates;

  bool _isEnrolling = false;
  bool get isEnrolling => _isEnrolling;

  Future<void> getApprovedCourses() async {
    _isLoading = true;
    update();

    Response response = await courseRepo.getApprovedCourses();
    if (response.statusCode == 200) {
      _approvedCourses = [];
      if (response.body != null) {
        final dataList = response.body is List ? response.body : response.body['results'];
        if (dataList != null) {
          dataList.forEach((course) {
            _approvedCourses!.add(CourseModel.fromJson(course));
          });
        }
      }
    } else {
      // Handle error
    }

    _isLoading = false;
    update();
  }

  Future<void> getMyProgress() async {
    _isLoading = true;
    update();

    Response response = await progressRepo.getMyProgress();
    if (response.statusCode == 200) {
      _myProgress = [];
      if (response.body != null) {
        final dataList = response.body is List ? response.body : response.body['results'];
        if (dataList != null) {
          dataList.forEach((progress) {
            _myProgress!.add(ProgressModel.fromJson(progress));
          });
        }
      }
    } else {
      // Handle error
    }

    _isLoading = false;
    update();
  }

  Future<void> getMyCertificates() async {
    _isLoading = true;
    update();

    Response response = await progressRepo.getMyCertificates();
    if (response.statusCode == 200) {
      _myCertificates = [];
      if (response.body != null) {
        final dataList = response.body is List ? response.body : response.body['results'];
        if (dataList != null) {
          dataList.forEach((cert) {
            _myCertificates!.add(CertificateModel.fromJson(cert));
          });
        }
      }
    }

    _isLoading = false;
    update();
  }

  Future<void> getCourseDetails(int id) async {
    _courseDetail = null;
    _isLoading = true;
    update();

    Response response = await courseRepo.getCourseDetail(id);
    if (response.statusCode == 200) {
      _courseDetail = CourseDetailModel.fromJson(response.body);
    } else {
      showCustomSnackBar('Failed to load course details', isError: true);
    }

    _isLoading = false;
    update();
  }

  Future<bool> enrollInCourse(int courseId) async {
    _isEnrolling = true;
    update();

    Response response = await progressRepo.enrollInCourse(courseId);
    bool isSuccess = false;
    if (response.statusCode == 201 || response.statusCode == 200) {
      isSuccess = true;
      showCustomSnackBar('Successfully enrolled!', isError: false);
      getMyProgress(); // refresh my courses
    } else {
      showCustomSnackBar('Failed to enroll. Maybe you are already enrolled?', isError: true);
    }

    _isEnrolling = false;
    update();
    return isSuccess;
  }
}
