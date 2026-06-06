import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/job_controller.dart';
import 'job_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobController>();
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('HireHub'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                onChanged: (value) => controller.searchJobs(value),
                decoration: InputDecoration(
                  hintText: 'Search jobs or companies',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            if (controller.isLoading.value)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (controller.hasError.value)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('Error loading jobs'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => controller.fetchJobs(),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              )
            else if (controller.filteredJobs.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No jobs found'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: controller.filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = controller.filteredJobs[index];
                    return Obx(
                      () => Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(job.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(job.companyName),
                              const SizedBox(height: 4),
                              Text(job.location),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              controller.isBookmarked(job.url)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                            ),
                            onPressed: () =>
                                controller.toggleBookmark(job.url),
                          ),
                          onTap: () => Get.to(
                            () => JobDetailScreen(job: job),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
