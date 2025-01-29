import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.info,
                size: 100,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'App Name: Finance Tracker',
              style: theme.textTheme.titleLarge, // Replaced headline6 with titleLarge
            ),
            const SizedBox(height: 10),
            Text(
              'Version: 1.0.0',
              style: theme.textTheme.bodyLarge?.copyWith( // Replaced bodyText1 with bodyLarge
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'About This App',
              style: theme.textTheme.titleLarge?.copyWith( // Replaced headline6 with titleLarge
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This app allows users to manage their profile, view transaction history, connect with friends, and more. It’s designed to enhance your experience by providing easy-to-use tools and features all in one place.',
              style: theme.textTheme.bodyMedium, // Replaced bodyText2 with bodyMedium
            ),
            const SizedBox(height: 20),
            Text(
              'Developer Info',
              style: theme.textTheme.titleLarge?.copyWith( // Replaced headline6 with titleLarge
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Developed by ADK Dev. If you have any questions, feel free to reach out at alee0066.aka@gmail.com.',
              style: theme.textTheme.bodyMedium, // Replaced bodyText2 with bodyMedium
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Thank you for using our app!',
                style: theme.textTheme.bodyLarge?.copyWith( // Replaced bodyText1 with bodyLarge
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
