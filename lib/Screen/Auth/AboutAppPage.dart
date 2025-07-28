import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About App',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.info,
                size: 100,
                color: colorScheme.primary, // Use primary color for the icon
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'App Name: Finance Tracker',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Version: 1.0.0',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant, // Use onSurfaceVariant for secondary text
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'About This App',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This app allows users to manage their profile, view transaction history, connect with friends, and more. It’s designed to enhance your experience by providing easy-to-use tools and features all in one place.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Developer Info',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Developed by ADK Dev. If you have any questions, feel free to reach out at alee0066.aka@gmail.com.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Thank you for using our app!',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: colorScheme.primary, // Use primary color for emphasis
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

