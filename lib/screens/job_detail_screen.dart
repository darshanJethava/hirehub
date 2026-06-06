import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../models/job_model.dart';

class JobDetailScreen extends StatelessWidget {
  final JobModel job;

  const JobDetailScreen({Key? key, required this.job}) : super(key: key);

  bool _isHtml(String text) {
    return RegExp(r'<[^>]*>').hasMatch(text);
  }

  Future<void> launchJobUrl(String url) async {
    if (url.isEmpty || url.trim().isEmpty) {
      Get.snackbar(
        'Info',
        'No application URL available',
      );
      return;
    }

    print('Job URL: $url');

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Get.snackbar(
        'Error',
        'Could not open application link',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    job.companyName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.blue.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        job.location,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(thickness: 1),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: _isHtml(job.description)
                        ? Html(
                            data: job.description,
                            style: {
                              'body': Style(
                                fontSize: FontSize(16),
                                lineHeight: LineHeight.number(1.6),
                                color: Colors.grey.shade800,
                              ),
                              'p': Style(
                                fontSize: FontSize(16),
                                lineHeight: LineHeight.number(1.6),
                                margin: Margins.symmetric(vertical: 8),
                              ),
                              'h1': Style(
                                fontSize: FontSize(24),
                                fontWeight: FontWeight.bold,
                                margin: Margins.symmetric(vertical: 12),
                              ),
                              'h2': Style(
                                fontSize: FontSize(20),
                                fontWeight: FontWeight.bold,
                                margin: Margins.symmetric(vertical: 10),
                              ),
                              'h3': Style(
                                fontSize: FontSize(18),
                                fontWeight: FontWeight.bold,
                                margin: Margins.symmetric(vertical: 8),
                              ),
                              'li': Style(
                                fontSize: FontSize(16),
                                lineHeight: LineHeight.number(1.6),
                                margin: Margins.symmetric(vertical: 6),
                              ),
                              'strong': Style(
                                fontWeight: FontWeight.bold,
                              ),
                              'b': Style(
                                fontWeight: FontWeight.bold,
                              ),
                              'a': Style(
                                color: Colors.blue,
                                textDecoration: TextDecoration.underline,
                              ),
                            },
                            onLinkTap: (url, attributes, element) async {
                              if (url != null) {
                                try {
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Could not open link'),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                          )
                        : Text(
                            job.description,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.grey.shade800,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => launchJobUrl(job.url),
                      child: const Text(
                        'Apply Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
