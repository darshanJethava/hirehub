import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/job_model.dart';

class JobController extends GetxController {
  RxList<JobModel> allJobs = <JobModel>[].obs;
  RxList<JobModel> filteredJobs = <JobModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxList<String> bookmarkedUrls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      final response = await http
          .get(Uri.parse('https://www.arbeitnow.com/api/job-board-api'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jobs = (data['data'] as List)
            .map((job) => JobModel.fromJson(job))
            .toList();
        allJobs.assignAll(jobs);
        filteredJobs.assignAll(jobs);
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void searchJobs(String query) {
    if (query.isEmpty) {
      filteredJobs.assignAll(allJobs);
    } else {
      final results = allJobs
          .where((job) =>
              job.title.toLowerCase().contains(query.toLowerCase()) ||
              job.companyName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredJobs.assignAll(results);
    }
  }

  void toggleBookmark(String url) {
    if (bookmarkedUrls.contains(url)) {
      bookmarkedUrls.remove(url);
    } else {
      bookmarkedUrls.add(url);
    }
  }

  bool isBookmarked(String url) => bookmarkedUrls.contains(url);
}
