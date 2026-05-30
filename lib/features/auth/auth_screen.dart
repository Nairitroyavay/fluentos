import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../providers/providers.dart';

enum _AuthMode { signIn, create }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Roy',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'roy@example.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'speakfirst',
  );
  _AuthMode _mode = _AuthMode.signIn;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    ref.read(authProvider.notifier).setLoading(true);
    ref.read(userProvider.notifier).updateName(_nameController.text);
    ref.read(userProvider.notifier).updateEmail(_emailController.text);

    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) {
      return;
    }

    ref.read(authProvider.notifier).signIn();
    final user = ref.read(userProvider);
    context.go(user.hasCompletedOnboarding ? '/home' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final isCreate = _mode == _AuthMode.create;
    final auth = ref.watch(authProvider);

    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _AuthHeader(),
                    const SizedBox(height: 28),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SegmentedButton<_AuthMode>(
                            segments: const [
                              ButtonSegment<_AuthMode>(
                                value: _AuthMode.signIn,
                                icon: Icon(Icons.login_rounded),
                                label: Text('Sign in'),
                              ),
                              ButtonSegment<_AuthMode>(
                                value: _AuthMode.create,
                                icon: Icon(Icons.person_add_alt_1_rounded),
                                label: Text('Create'),
                              ),
                            ],
                            selected: {_mode},
                            showSelectedIcon: false,
                            onSelectionChanged: auth.isLoading
                                ? null
                                : (selection) {
                                    setState(() => _mode = selection.first);
                                  },
                          ),
                          const SizedBox(height: 22),
                          if (isCreate) ...[
                            TextField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: 'Name',
                                prefixIcon: Icon(Icons.badge_outlined),
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.alternate_email_rounded),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            onSubmitted: (_) =>
                                auth.isLoading ? null : _continue(),
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                            ),
                          ),
                          const SizedBox(height: 22),
                          PrimaryActionButton(
                            label: auth.isLoading
                                ? 'Creating coach profile...'
                                : isCreate
                                ? 'Create account'
                                : 'Continue',
                            icon: auth.isLoading
                                ? Icons.hourglass_top_rounded
                                : isCreate
                                ? Icons.person_add_alt_1_rounded
                                : Icons.arrow_forward_rounded,
                            onPressed: auth.isLoading ? null : _continue,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const MockPermissionCard(
                      title: 'Frontend demo',
                      body:
                          'Sign-in is fake and local. No account, voice, or payment data leaves this app.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppPill(label: 'Speaking first', icon: Icons.graphic_eq_rounded),
        SizedBox(height: 18),
        Text(
          'Start with your voice.',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'One active language. Daily missions. Corrections you repeat until they feel natural.',
          style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
        ),
      ],
    );
  }
}
